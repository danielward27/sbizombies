library(sbizombies)

pbs_idx = as.integer(Sys.getenv(x = "PBS_ARRAY_INDEX"))
if (is.na(pbs_idx)){
  pbs_idx = 1 # So can run locally
}
set.seed(pbs_idx)

s_obs = read.table(paste0("sa_projections/???????", pbs_idx, ".txt"))
prior = read.table("?????????")
s_obs = as.vector(unlist(s_obs))

s = szr(prior, N = 1000, tf = length(s_obs)/2, initial = FALSE)
res = abc_rej(prior, s, s_obs, q=0.002)

outfile_posterior = paste0("sa_results/sa_posterior_", pbs_idx, ".txt")
write.table(res$posterior, outfile_posterior, col.names = FALSE, row.names = FALSE)
