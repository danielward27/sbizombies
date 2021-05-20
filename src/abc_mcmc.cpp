#include <Rcpp.h>
#include "dprior.h"
#include "prop_mech.h"
#include "szr.h"
#include "distance.h"

using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix abc_mcmc(NumericVector obs, int N, NumericVector sd, NumericMatrix prior_params, NumericVector epsilon, NumericMatrix scale_ss) {

  int tf = (obs.size()/2);
  int length_theta = 2;
  int N_pop = 1000;
  int length_ss = (2*tf);

  // // pilot run
  // int N_pilot = 1000;
  // NumericMatrix pilot_draws(N_pilot, length_theta);
  // NumericMatrix pilot_ss(N_pilot, length_ss);
  // double pilot_fir_param;
  // double pilot_sec_param;
  // for (int ii=0; ii<N_pilot; ii++) {
  //   for (int jj = 0; jj < length_theta; jj++) {
  //     pilot_fir_param = prior_params(jj,0);
  //     pilot_sec_param = prior_params(jj,1);
  //     pilot_draws(ii , jj) = R::runif(pilot_fir_param, pilot_sec_param);
  //   }
  // }
  // pilot_ss = szr(pilot_draws, N_pop, tf, true);

  // scale obs
  NumericVector obs_scale(length_ss);
  obs_scale = (obs-scale_ss(0,_))/(scale_ss(1,_));

  // initialize chain using the runif params
  NumericMatrix chain(N, length_theta);
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
  NumericMatrix prop_mat(1, length_theta);
  NumericMatrix prop_ss(1, length_ss);
  NumericMatrix prop_ss_scale(1, length_ss);
  double dist;
  double prior_ratio;
  double prior_num;
  double prior_den;
  for (int i = 1; i < N; i++) {
    std::cout << i << std::endl;
    // find prop and old
    prop = prop_mech(chain(i-1 , _), sd);
    old = chain(i-1 , _);

    prop_mat(0,_) = prop;// convert into matrix for use in szr function
    prop_ss(0,_) = szr(prop_mat, N_pop, tf, false);// push through forward model to get ss

    prop_ss_scale(0,_) = (prop_ss(0,_)-scale_ss(0,_))/(scale_ss(1,_));
    // std::cout << prop_ss_scale.size() << std::endl;
    // std::cout << prop_ss.size() << std::endl;

    dist = distance(prop_ss, obs)(0); //calc distance

    std::cout << dist << std::endl;

    if (dist > epsilon(i)) {
      chain(i,_) = chain(i-1,_);
      // std::cout << "immediately rej bcoz ss" << std::endl;
    } else {
      // prior evals
      prior_num = dprior(prop, prior_params);
      prior_den = dprior(old, prior_params);
      prior_ratio = prior_num / prior_den;
      if (prior_ratio == 1) {
        chain(i,_) = prop; //accpt
        // std::cout << "accept!!!" << std::endl;
      } else {
        chain(i,_) = chain(i-1,_); //rej
        // std::cout << "reject bcoz prior" << std::endl;
      }
    }

    // std::cout << "here is chain" << std::endl;
    // std::cout << chain << std::endl;


  }


  return chain;
}

  /*** R
obs = c(1,1,2,5,7,12,17,30,48,71,101,147,172,150,98,59,31,24,9,4,2,1,1,0,1,1,2,6,12,20,33,58,98,151,227,334,469,588,667,716,737,756,762,765,767,767)
N_temp = 2.5e5
sd = c(1,1)
burn_in = 25000
prior_params = matrix(c(rep(0,2), rep(5, 2)), 2, 2)
epsilon = c(seq(10000,1000,length.out=burn_in), rep(1000,N_temp-burn_in))
scale_ss = matrix(c(round(seq(2, 200, length.out=20)),
                    round(seq(2, 200, length.out=20)),
                    round(seq(2,50,length.out=20)),
                    round(seq(2,50,length.out=20))),
                    nrow=2, ncol=40, byrow=T)
output = abc_mcmc(obs, N_temp, sd, prior_params, epsilon, scale_ss)
length(unique(output[burn_in:N_temp,1]))/length(output[burn_in:N_temp,1])*100
plot(output[burn_in:N_temp,1], type="l")
plot(output[burn_in:N_temp,2], type="l")
hist(output[burn_in:N_temp,1], prob=TRUE)
hist(output[burn_in:N_temp,2], prob=TRUE)
  */
