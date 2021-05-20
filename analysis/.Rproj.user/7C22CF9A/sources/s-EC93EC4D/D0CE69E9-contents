# Utility functions


#' Calculate colmeans and colstds
#'
#' @param s Summary statistic vector
#' @return List with mean and sd
#' @export
mean_and_sd = function(s){
  means = colMeans(s)
  sds = apply(s, MARGIN = 2, FUN = sd)
  list(mean = means, sd = sds)
}


#' Scale matrix or vector
#'
#' @param s Matrix or vector
#' @param mean_and_sd Mean and sd list (from mean_and_sd)
#' @return scaled matrix or vector
scaler = function(s, mean_and_sd){
  means = mean_and_sd$mean
  sds = mean_and_sd$sd

  if (all.equal(min(sds), 0) == TRUE){
    stop("Cannot scale with standard deviation of zero.")
  }

  if (is.matrix(s)){
    result = t((t(s) - means)/sds)
  }
  else {
    result = (s - means)/sds
  }
  result
}

