algorithms = c("mcmc", "rej", "sa")

pbs_idx = as.integer(Sys.getenv(x = "PBS_ARRAY_INDEX"))
if (is.na(pbs_idx)){
  pbs_idx = 1 # So can run locally
}

for (algorithm in algorithms){
  results_path = paste0(algorithm, "_results/", algorithm, "_posterior_", pbs_idx, ".txt")
  outfile = paste0("posterior_mean_parts/", algorithm, "_posterior_mean", "_", pbs_idx, ".txt")

  posterior = read.table(results_path)
  print(dim(posterior))
  posterior_means = colMeans(posterior)
  write.table(posterior_means, outfile, col.names = FALSE, row.names = FALSE)
}
