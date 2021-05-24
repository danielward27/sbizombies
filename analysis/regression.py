import numpy as np
import pandas as pd

import matplotlib.pyplot as plt

from tensorflow import keras
from keras.models import Sequential
from keras.layers import Dense

from sklearn.datasets import make_regression
from sklearn.model_selection import RepeatedKFold

#def get_dataset():
#    X, y = make_regression(n_samples=1000000, n_features=100, n_informative=100, n_targets=2, random_state=2)
#    return X,y


def get_dataset():
    X = np.loadtxt('s_1.txt')
    y = np.loadtxt('theta_1.txt')
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

        print(i)
        model = define_network(n_inputs,n_outputs,lam = lam[i])

        model.fit(X_train,y_train,verbose=2,epochs =4)
        
        mse = model.evaluate(X_val,y_val,verbose = 0)

        print('>%.3f'% mse)
        results.append(mse)

        i+=1

    lam_index = results.index(min(results))

    model = define_network(n_inputs,n_outputs,lam = lam[lam_index])
    
    model.fit(X_train,y_train,verbose=2,epochs =50)

    return model


X, theta = get_dataset()

X_train,X_test = np.array_split(X,2)
theta_train, theta_test = np.array_split(theta,2)

model = cross_val(X_train, theta_train)

theta_hat = model.predict(X_test)

np.savetxt('theta_hat.txt',theta_hat)

fig1, ax1 = plt.subplots()

ax1.scatter(theta_test[:1000,0],theta_hat[:1000,0],s=10)

lims = [    np.min([ax1.get_xlim(), ax1.get_ylim()]),    np.max([ax1.get_xlim(), ax1.get_ylim()]), ]
ax1.plot(lims, lims, 'k-', alpha=0.75, zorder=0)
ax1.set_aspect('equal')
ax1.set_xlim(lims)
ax1.set_ylim(lims)

ax1.set_xlabel('theta_1')
ax1.set_ylabel('theta_hat_1')

fig1.savefig('theta1.png')

fig2,ax2 = plt.subplots()

ax2.scatter(theta_test[:1000,1],theta_hat[:1000,1],s=10)

lims = [    np.min([ax2.get_xlim(), ax2.get_ylim()]),    np.max([ax2.get_xlim(), ax2.get_ylim()]), ]
ax2.plot(lims, lims, 'k-', alpha=0.75, zorder=0)
ax2.set_aspect('equal')
ax2.set_xlim(lims)
ax2.set_ylim(lims)

ax2.set_xlabel('theta_2')
ax2.set_ylabel('theta_hat_2')

fig2.savefig('theta2.png')


