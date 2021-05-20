#include <Rcpp.h>
using namespace Rcpp;

//' @export
// [[Rcpp::export]]
NumericVector distance(NumericMatrix sims, NumericVector obs) {
  int nsims = sims.nrow();
  int ndims = sims.ncol();
  
  if (obs.size() != ndims) {
    throw std::runtime_error("Incompatible number of dimensions");
  }
  
  NumericVector out(nsims);

  for (int i = 0; i < nsims; i++) {
    out(i) = sqrt(sum( pow( (sims( i , _ ) - obs), 2) ));
  }
  
  return out;
}
