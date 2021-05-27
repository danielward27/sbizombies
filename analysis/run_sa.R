library(sbizombies)
# devtools::load_all("..")
pbs_idx = as.integer(Sys.getenv(x = "PBS_ARRAY_INDEX"))
if (is.na(pbs_idx)){
  pbs_idx = 1 # So can run locally
}
set.seed(pbs_idx)

s_file = paste0("nn_output/theta_hat", pbs_idx, ".txt")
s_obs_file = paste0("nn_output/theta_hat_obs_", pbs_idx, ".txt")
prior_file = paste0("sa_data/theta_", pbs_idx, ".txt")

s = read.table(s_file, header =  FALSE)
s = as.matrix(unname(s))

s_obs = read.table(s_obs_file)
s_obs = as.vector(unlist(s_obs))

prior = read.table(prior_file)
prior = prior[500001:nrow(prior), ]

res = abc_rej(prior, s, s_obs, q=0.002)

outfile_posterior = paste0("sa_results/sa_posterior_", pbs_idx, ".txt")
write.table(res$posterior, outfile_posterior, col.names = FALSE, row.names = FALSE)
