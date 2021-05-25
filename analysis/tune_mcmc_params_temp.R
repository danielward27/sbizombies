sdtry = seq(0.1, 2, length.out=10)

reslist = vector("list", length=10)
lengths = rep(0,10)
n_sim = 1e6
burn_in = 2.5e5
pbs_idx=1

for (j in 1:10) {
  sd = rep(sdtry[j],2)
  prior_params = matrix(c(rep(0,2), rep(5, 2)), 2, 2) #params for the prior
  epsilon = c(seq(10000,125,length.out=burn_in),
              rep(125,n_sim-burn_in))#value of epsilon for accp/rej  @@@@ READ FROM FILE

  scale_file = paste0("rej_results/rej_scale_", pbs_idx,".txt")
  scale_ss = t(read.table(scale_file))

  s_obs = read.table(paste0("pods/pod_s_", pbs_idx, ".txt"))
  s_obs = as.vector(unlist(s_obs))

  reslist[[j]] = abc_mcmc(s_obs, n_sim, sd, prior_params, epsilon, scale_ss)
}

for (j in 1:10) {
  lengths[j] =length(unique(reslist[[j]][(burn_in+1):n_sim,1]))/n_sim
}


plot(density(reslist[[1]][(burn_in+1):n_sim,2]), col=1)
for (j in 2:10) {
  lines(density(reslist[[j]][(burn_in+1):n_sim,2]), col=j)
}
legend("topright", c("1","2","3","4","5","6","7","8","9","10"),col=1:10, lwd=rep(1,10))

plot(density(reslist[[1]][(burn_in+1):n_sim,1]), col=1)
for (j in 2:10) {
  lines(density(reslist[[j]][(burn_in+1):n_sim,1]), col=j)
}
legend("topright", c("1","2","3","4","5","6","7","8","9","10"),col=1:10, lwd=rep(1,10))

