#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix sirc(NumericMatrix theta, double N, double tf, bool initial = true){

// initialising variables
      
  double S0 = N - 1;
  double I0 = 1;
  double R0 = 0;
  
  int Nruns = theta.nrow();
  
  // return error if theta is of incorrect dimension for initial run
  
  if(Nruns>1 && initial == true){
    
    throw std::invalid_argument("initial run must have only one set of parameters");
    
    return -1;
  }
  
  // initialising output elements
  
  NumericVector IR;
  
  NumericMatrix X(Nruns, 2*tf);
  
  int n;

  // loop over the number of runs
  
  for (int i = 0; i < Nruns; i++){
  
    double beta = theta(i,0);
    double gamma = theta(i,1);
  
    double t = 1;
    double S = S0;
    double I = I0;
    double R = R0;
    NumericVector ta;
    NumericVector Sa;
    NumericVector Ia;
    NumericVector Ra;

    
    do{
      
      // append the new populations to the vectors
      
      ta.push_back(t);
      Sa.push_back(S);
      Ia.push_back(I);
      Ra.push_back(R);
      
      // calculate the updates
      
      double lambd = beta*I/N;
      double ifrac = 1.0 -exp(-lambd);
      double rfrac = 1.0 - exp(-gamma);
      double  infection = as<double>(rbinom(1,S,ifrac));
      double recovery = as<double>(rbinom(1,I,rfrac));
      
      // updates the populations
      
      S-=infection;
      I= I +infection - recovery;
      R+= recovery;
      t++;
      
      // conditional break on initial run
      
      if(initial == true){
        if(I==0){break;}
      }
      
    } while (t<=tf );
    
    // concatenating the I and R vector. This is our sumarary statistic.
    
    NumericVector IR(Ia.size() + Ra.size()); // preallocate memory
  
    for(int i= 0; i < Ia.size(); i++ ){
  
      IR.insert(i,Ia[i]);
    }
  
    for(int j= 0; j < Ra.size(); j++ ){
  
      IR.insert(j+Ia.size(),Ra[j]);
    }
    
    // adding the summary statistic to the output matrix
    
    X(i,_) =  IR[Range(0,2*Ia.size())];
    
    n = 2*Ia.size();
  
    }

  return X(_,Range(0,n-1));
}


/*** R
# initial
theta = matrix(c(0.1,0.05),nrow=1)
sirc(theta,1000,500)
## training
theta = matrix(runif(4),nrow=2)
sirc(theta,1000,50,initial = F)
*/




