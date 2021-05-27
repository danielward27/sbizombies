## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----message=FALSE----------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)
theme_set(theme_bw())

## ---------------------------------------------------------------------------------------------------------------------------------------------------
pod_list = list()
for (i in 1:100){
  pod_file = paste0("pods/pod_theta_", i, ".txt")
  data = read.table(pod_file, col.names = c("beta", "gamma"))
  pod_list = append(pod_list, list(data))
}

true_parameters = do.call("rbind", pod_list)

## ---------------------------------------------------------------------------------------------------------------------------------------------------
algorithms = c("rej", "mcmc", "sa")
logprobs = data.frame(rej=rep(NA,100), mcmc=rep(NA,100), sa=rep(NA,100))

data_list = list()
for (algorithm in algorithms){
  for (i in 1:100) {
    data_file = paste0(algorithm, "_results/", algorithm, "_posterior_", i, ".txt")
    alg_df = read.table(data_file, col.names = c("beta", "gamma"))
    
    if (nrow(alg_df) == 0){
      next
    }
    
    beta_dens = approxfun(density(alg_df[,1]))
    gamma_dens = approxfun(density(alg_df[,2]))
    beta_prob = beta_dens(true_parameters[i,1])
    gamma_prob = gamma_dens(true_parameters[i,2])

    logprobs[i, algorithm] = -log(beta_prob * gamma_prob)
  }
}

## ---------------------------------------------------------------------------------------------------------------------------------------------------
logprobs = rename(logprobs, rejection = rej, semi_automatic = sa)

write.csv(logprobs, "metrics/logprobs.csv", row.names = FALSE)

