library(sbizombies)

pbs_idx = as.integer(Sys.getenv(x = "PBS_ARRAY_INDEX"))
if (is.na(pbs_idx)){
  pbs_idx = 1 # So can run locally
}


devtools::load_all("..")

for (i in 1:100){
  theta = tc(beta = runif(0,3), gamma = runif(0,3))  
  result = szr(theta, N = 1000, tf=1000)
}



abc_rej()

n = 1
beta = runif(0, 3)
gamma = runif(0, 1)



theta = matrix(runif(100), 50, 2)



results = sirc(theta, 100, 99, 1, 0, 20, 10)

library(tidyverse)
dim(results)

# Index the correct observation

# Generate results
results = matrix(runif(3400), 34, 10)  #  Placeholder results
results = cbind(pbs_idx, results)

outfile = paste0("result_chunks/result_", pbs_idx, ".txt")
write.table(results, outfile, col.names = FALSE, row.names = FALSE)


funrnorm()
