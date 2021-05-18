#' @export
abc_rej = function(obs, N, simulator, prior, summary, quant) {
  
  #transform observed
  obs_ss = summary(obs)
  
  abc_params = prior(N) #generate params to simulate with
  abc_simuls = simulator(abc_params) #generate the respective simulations
  abc_ss = summary(abc_simuls) #generate summary statistics
  
  scale_out = mean_and_sd(abc_ss) #find scaling
  #apply scaling
  abc_ss_scale = scale(abc_ss, scale_out)
  obs_ss_scale = scale(obs_ss, scale_out)
  
  abc_dists = distance(abc_ss_scale, obs_ss_scale) #find distances
  
  ep = as.numeric(quantile(abc_dists, quant)) #e.g. quant = 0.01
  abc_accp = (abc_dists < ep)
  
  return(abc_params[abc_accp])
  
}