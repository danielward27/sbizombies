#include <Rcpp.h>
#include "dprior.h"
#include "prop_mech.h"
// #include "distance.h"

using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix abc_mcmc(NumericVector obs, int N, NumericVector sd, NumericMatrix prior_params, double epsilon) {
      
  // double obs_ss = mean(obs);
  
  int length_theta = obs.size();
  NumericMatrix chain(N, length_theta);
  double prior_ratio;
  double prior_num;
  double prior_den;
  
  // initialize chain using the runif params
  double curr_fir_param;
  double curr_sec_param;
  for (int j = 0; j < length_theta; j++) {
    curr_fir_param = prior_params(j,0);
    curr_sec_param = prior_params(j,1);
    chain(0 , j) = R::runif(curr_fir_param, curr_sec_param);
  }
  
  // mcmc step!
  NumericVector prop(length_theta);
  NumericVector old(length_theta);
  for (int i = 1; i < (N-1); i++) {
    // find prop and old
    prop = prop_mech(chain(i-1 , _), sd);
    old = chain(i-1 , _);
    
    // summary stats rej / accp
    
    // prior evals
    prior_num = dprior(prop, prior_params);
    prior_den = dprior(old, prior_params);
    prior_ratio = prior_num / prior_den;
    
    // stuff
    std::cout << prior_ratio << std::endl;

  }
  
  
  return chain;
}
  
  /*** R
obs = 1:6
N = 10
sd = rep(1,6)
prior_params = matrix(c(rep(0,6), rep(10, 6)), 6, 2)
epsilon = 0.05
abc_mcmc(obs, N, sd, prior_params, epsilon)
*/