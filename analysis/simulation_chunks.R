devtools::load_all("..")

pbs_idx = as.integer(Sys.getenv(x = "PBS_ARRAY_INDEX"))
if (is.na(pbs_idx)){
  pbs_idx = 1 # So can run locally
}

n_sim = 10000
prior = cbind(runif(n_sim, 0, 3), runif(n_sim, 0, 3))

s_obs = read.table(paste0("pods/pod_s_", pbs_idx, ".txt"))
s_obs = as.vector(unlist(s_obs))

s = szr(prior, N = 1000, tf = length(s_obs)/2, initial = FALSE)


res = abc_rej(prior, s, s_obs)



library(tidyverse)
dim(results)

# Index the correct observation

# Generate results
results = matrix(runif(3400), 34, 10)  #  Placeholder results
results = cbind(pbs_idx, results)

outfile = paste0("result_chunks/result_", pbs_idx, ".txt")
write.table(results, outfile, col.names = FALSE, row.names = FALSE)


funrnorm()
