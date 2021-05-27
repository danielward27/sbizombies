import os

PBS_ID = os.environ['$PBS_ARRAYID']

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'

import numpy as np

from tensorflow import keras
from keras.models import Sequential
from keras.layers import Dense

from sklearn.datasets import make_regression
from sklearn.model_selection import RepeatedKFold



def get_dataset(PBS_ID):
    X = np.loadtxt('s_'+ PBS_ID + '.txt')
    y = np.loadtxt('theta_' + PBS_ID + '.txt')
    return X,y


def define_network(n_inputs,n_outputs,lam):
    model = Sequential()
    model.add(Dense(20,input_dim=n_inputs,kernel_initializer = 'he_uniform',activation='swish',kernel_regularizer=keras.regularizers.l2(l=lam)))
    model.add(Dense(n_outputs,kernel_regularizer=keras.regularizers.l2(l=lam)))
    model.compile(loss='mse',optimizer='adam')
    return model


def cross_val(X,y):
    results = list()
    n_inputs,n_outputs = X.shape[1],y.shape[1]

    n_split = 5
    n_repeat = 1

    cv = RepeatedKFold(n_splits=n_split,n_repeats=n_repeat,random_state=1)

    lam = [10**i for i in np.linspace(-5,0,n_split*n_repeat)]

    i = 0

    for train_ix, val_ix in cv.split(X):

        X_train, X_val = X[train_ix],X[val_ix]
        y_train,y_val = y[train_ix],y[val_ix]

        model = define_network(n_inputs,n_outputs,lam = lam[i])

        model.fit(X_train,y_train,verbose=0,epochs =4)

        mse = model.evaluate(X_val,y_val,verbose = 0)


        results.append(mse)

        i+=1

    lam_index = results.index(min(results))

    model = define_network(n_inputs,n_outputs,lam = lam[lam_index])

    model.fit(X_train,y_train,verbose=0,epochs =20)

    return model




X, theta = get_dataset(PBS_ID)

X_train,X_test = np.array_split(X,2)
theta_train, theta_test = np.array_split(theta,2)

model = cross_val(X_train, theta_train)

theta_hat = model.predict(X_test)

np.savetxt('theta_hat' + PBS_ID + '.txt',theta_hat)


xobs = np.loadtxt('pod_s_'+ PBS_ID + '.txt')

xobs = np.array([xobs])

theta_hat_obs = model.predict(xobs)

np.savetxt('theta_hat_obs_'+PBS_ID + '.txt',theta_hat_obs)

