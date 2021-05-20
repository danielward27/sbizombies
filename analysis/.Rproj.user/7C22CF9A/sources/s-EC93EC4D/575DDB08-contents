library(sbizombies)

pbs_idx = as.integer(Sys.getenv(x = "PBS_ARRAY_INDEX"))
if (is.na(pbs_idx)){
  pbs_idx = 1 # So can run locally
}
set.seed(pbs_idx)

n_sim = 1000000
prior = cbind(runif(n_sim, 0, 5), runif(n_sim, 0, 5))

s_obs = read.table(paste0("pods/pod_s_", pbs_idx, ".txt"))
s_obs = as.vector(unlist(s_obs))

s = szr(prior, N = 1000, tf = length(s_obs)/2, initial = FALSE)
res = abc_rej(prior, s, s_obs, q=0.001)

outfile_posterior = paste0("rej_results/rej_posterior_", pbs_idx, ".txt")
outfile_s = paste0("rej_results/rej_s_", pbs_idx, ".txt")
outfile_scale = paste0("rej_results/rej_scale_", pbs_idx, ".txt")

scale = cbind(mean = res$s_mean, sd = res$s_sd)

write.table(res$posterior, outfile_posterior, col.names = FALSE, row.names = FALSE)
write.table(res$s, outfile_s, col.names = FALSE, row.names = FALSE)
write.table(scale, outfile_scale, col.names = FALSE, row.names = FALSE)
