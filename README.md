# sbizombies
An R Package for Simulation-based inference on zombie outbreak models.


We create functions that both simulate data from an SIR model (here SZR since we are modelling a hypothetical zombie outbreak) 
                    as well as functions that are used in performing Rejection ABC, Monte Carlo Markov Chain ABC and Semiautomatic ABC. 
                    The backend of the package has been written using Rcpp to give substantial computational speedup.

Parallelisation for this package is possible through the use of array jobs in the HPC cluster BluePebble. Example array job scripts can be found in the directory - 'analysis'.
