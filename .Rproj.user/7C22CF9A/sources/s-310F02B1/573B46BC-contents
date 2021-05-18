#' @export
abc_sir = function(obs, N, ep_acc, prior) {
  
  obs_ss = ss(obs)
  
  abc_params = sir_prior(N)
  abc_simuls = simulate(abc_params)
  abc_ss = ss(abc_simuls)
  
  scale_out = mean_and_sd(obs_ss)
  abc_ss_scale = scale(abc_ss, scale_out)
  obs_ss_scale = scale(obs_ss, scale_out)
  
  abc_dists = distance(abc_ss_scale, obs_ss_scale)
  
  ep = quantile(abc_dists, ep_acc) #e.g. ep_acc = 0.01
  abc_accp = (abc_dists < ep)
  
  return(abc_params[abc_accp])
  
}