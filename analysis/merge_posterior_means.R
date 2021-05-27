algorithms = c("mcmc", "rej", "sa")

algorithms = c("mcmc")
for (algorithm in algorithms){
  alg_means = list()
  for (i in 1:100){
    posterior_mean_file = paste0("posterior_mean_parts/", algorithm, "_posterior_mean", "_", i, ".txt")
    
    if (file.exists(posterior_mean_file)){
      means = t(read.table(posterior_mean_file))
    } else {
      print(paste("Warning file", i, "missing for algorithm", algorithm))
      means = t(c(NA, NA))
    }
    alg_means = append(alg_means, list(means))
  }
  alg_means = do.call("rbind", alg_means)

  outfile = paste0("posterior_means/", algorithm, "_posterior_means.txt")
  write.table(alg_means, outfile, col.names = FALSE, row.names = FALSE)
}
