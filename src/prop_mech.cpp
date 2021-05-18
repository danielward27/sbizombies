#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector prop_mech(NumericVector old, NumericVector sd) {
  
  int leng = old.size();
  
  NumericVector out(leng);
  
  double abc;
  
  for (int i = 0; i < leng; i++) {
    out(i) = rnorm(1, old(i), sd(i))[0];
  }
  
  return out;
}

/*** R
old = 1:6
sd = 1:6
prop_mech(old, sd)
*/
