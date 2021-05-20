#' @export
abc_mcmc_r = function(obs, N, simulator, prior, summary, quant, proposal, dprior, burn_in) {

  #transform observed
  obs_ss = summary(obs)

  #pilot to find epsilon and the scaling factors
  pilot_props = prior(burn_in)
  pilot_sim = simulator(pilot_props)
  pilot_ss = summary(pilot_sim)
  scale_out = mean_and_sd(pilot_ss)
  pilot_ss_scale = scale(pilot_ss, scale_out)
  obs_ss_scale = scale(obs_ss, scale_out)
  pilot_dists = distance(pilot_ss_scale, obs_ss_scale)
  ep = as.numeric(quantile(pilot_dists, quant)) #e.g. quant = 0.01

  #initialize
  length_theta = length(obs) #
  chain_out = matrix(0, N+burn_in, length_theta) #initialise the whole chain
  chain_out[1,] = prior(1) #get first prop

  #mcmc loop
  for (i in 2:(N+burn_in)) {
    prop = proposal(chain_out[i-1,]) #propose
    prop_sim = simulator(prop) #simulate
    prop_ss = summary(prop_sim) #summarise
    prop_ss_scale = scale(prop_ss, scale_out) #scale
    rej_bool = dist(obs_ss_scale, prop_ss_scale) < ep #see if bool = 1 or 0
    accp_prob = min(1, (dprior(prop)/dprior(chain_out[i-1,]))*rej_bool) #find accp prob
    if (runif(1)< accp_prob) {
      chain_out[i,] = prop #accept
    } else {
      chain_out[i,] = chain_out[i-1,] #reject
    }
  }

  #discard burn_in
  chain_out = chain_out[(burn_in+1):(burn_in+N)]

  return(chain_out)

}
