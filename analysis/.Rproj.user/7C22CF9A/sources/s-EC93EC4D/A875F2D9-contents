library(sbizombies)

pbs_idx = as.integer(Sys.getenv(x = "PBS_ARRAY_INDEX"))
if (is.na(pbs_idx)){
  pbs_idx = 1 # So can run locally
}

n_sim = 1e6
burn_in = 2.5e5
sd = c(1,1) #sds for the proposal dist

prior_params = matrix(c(rep(0,2), rep(5, 2)), 2, 2) #params for the prior
epsilon = c(seq(10000,1000,length.out=burn_in),
            rep(1000,n_sim-burn_in))#value of epsilon for accp/rej  @@@@ READ FROM FILE

scale_file = paste0("rej_results/rej_scale_", pbs_idx,".txt")
scale_ss = t(read.table(scale_file))

s_obs = read.table(paste0("pods/pod_s_", pbs_idx, ".txt"))
s_obs = as.vector(unlist(s_obs))

res = abc_mcmc(s_obs, n_sim, sd, prior_params, epsilon, scale_ss)

outfile_posterior = paste0("mcmc_results/mcmc_posterior_", pbs_idx, ".txt")

write.table(res, outfile_posterior, col.names = FALSE, row.names = FALSE)
