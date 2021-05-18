library(Rcpp)

cppFunction(
  "double temp(int n, int m) {
    
    NumericMatrix chain(n, m);
    NumericVector temp(m);
    double temp_mean;
    
    
    chain(0 , _) = rnorm(m);
    
    for (int i = 0; i < (n-1); i++) {
      temp_mean = mean( chain(i , _) );
      chain(i+1 , _) = rnorm(m, temp_mean, 1);
    }
        

    return temp_mean;
  }"
)

temp(10,15)

for (int i = 0; i < n; i++) {
  calc_mean = mean(temp);
  temp = chain(i , _);
  calc_mean = mean(temp);
  chain(i+1 , _) = rnorm(m, calc_mean, 1);
}