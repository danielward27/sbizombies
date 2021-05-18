library(Rcpp)

cppFunction(
  "NumericVector temp(int n, int m) {
    
    NumericMatrix chain(n, m);
    double calc_mean;
    NumericVector temp;
    
    
    
    chain(0 , _) = rnorm(m);
    
    temp = chain(0 , _);
    
    calc_mean = mean(temp);
    
    // for (int i = 0; i < n; i++) {
    //   temp = chain(i , _);
    //   calc_mean = mean(temp);
    //   chain(i+1 , _) = rnorm(m, calc_mean, 1);
    // }
    
    
    return calc_mean;
  }"
)