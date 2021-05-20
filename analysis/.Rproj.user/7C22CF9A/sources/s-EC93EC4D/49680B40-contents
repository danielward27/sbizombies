
#' Rejection ABC
#' @param prior Matrix of parameters from the prior
#' @param s Matrix of corresponding summary statistics
#' @param obs Vector of observed summary statistics
#' @param q Distance quantile under which simulations are excepted
#' @export
abc_rej = function(prior, s, s_obs, q = 0.01) {
  stopifnot(nrow(prior) == nrow(s))
  stopifnot(length(s_obs) == ncol(s))

  # Scale summary statistics
  scale_out = mean_and_sd(s)
  s_scaled = scaler(s, scale_out)
  s_obs_scaled = scaler(s_obs, scale_out)

  # Calculate dists and reject
  dists = distance(s_scaled, s_obs_scaled)
  stopifnot(!any(is.na(dists)))
  threshold_dist = quantile(dists, q)
  accept = dists < threshold_dist
  result = list(posterior = prior[accept, ],
                s = s[accept, ],
                s_mean = scale_out$mean,
                s_sd = scale_out$sd,
                threshold_used = threshold_dist)
  result
}
