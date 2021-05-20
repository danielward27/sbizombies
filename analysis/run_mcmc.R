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
scale_ss = matrix(c(round(seq(2, 200, length.out=20)),
                    round(seq(2, 200, length.out=20)),
                    round(seq(2,50,length.out=20)),
                    round(seq(2,50,length.out=20))),
                  nrow=2, ncol=40, byrow=T)#@@@@ READ FROM FILE

s_obs = read.table(paste0("pods/pod_s_", pbs_idx, ".txt"))
s_obs = as.vector(unlist(s_obs))

res = abc_mcmc(s_obs, n_sim, sd, prior_params, epsilon, scale_ss)

outfile_posterior = paste0("rej_results/rej_posterior_", pbs_idx, ".txt")
outfile_s = paste0("rej_results/rej_s_pod_", pbs_idx, ".txt")

write.table(res, outfile_posterior_abc, col.names = FALSE, row.names = FALSE)
