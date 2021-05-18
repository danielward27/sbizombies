#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double dprior(NumericVector vals, NumericMatrix params) {
  
  int numrow = params.nrow();
  
  double out = 1;
  double curr_val;
  double curr_first_param;
  double curr_second_param;
  
  for (int i = 0; i < numrow; i++) {
    curr_val = vals(i);
    curr_first_param = params(i,0);
    curr_second_param = params(i,1);
    out = out * R::dunif(curr_val, curr_first_param, curr_second_param, 0);
  }
  
  return out;
}

/*** R
vals = 1:6
params =  matrix(c(rep(0,6), rep(10, 6)), 6, 2)
dprior(vals, params)
*/
