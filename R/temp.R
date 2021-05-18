library(Rcpp)

cppFunction(
  "NumericMatrix temp(NumericVector obs, int N) {
    
    double obs_ss = mean(obs);
  
    int length_theta = obs.size();
    NumericMatrix chain(N, length_theta);
    NumericVector update(length_theta);
    update = rnorm(length_theta, 1, 1);
  
    chain(0 , _) = update;
    
    
    NumericVector prop(length_theta);
    for (int i = 1; i < (N-1); i++) {
      prop = 
    }
        

    return chain;
  }"
)

temp(rnorm(21,0,1),10)
