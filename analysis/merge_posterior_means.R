algorithms = c("mcmc", "rej")

for (algorithm in algorithms){
  alg_means = list()
  for (i in 1:100){
    posterior_mean_file = paste0("posterior_mean_parts/", algorithm, "_posterior_mean", "_", i, ".txt")
    means = t(read.table(posterior_mean_file))
    alg_means = append(alg_means, list(means))
  }
  alg_means = do.call("rbind", alg_means)

  outfile = paste0("posterior_means/", algorithm, "_posterior_means.txt")
  write.table(alg_means, outfile, col.names = FALSE, row.names = FALSE)
}


