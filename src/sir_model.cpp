#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector sirc(double beta, double gamma, double iota, double N, double S0, double I0, double R0, double tf, bool initial = true, int Nruns = 1){
  
  //initialise matrix tf by nruns
  
  // NumericMatrix X;
  // 
  // for (int i = 0; i < Nruns; i++){
  
  double t = 0;
  double S = S0;
  double I = I0;
  double R = R0;
  NumericVector ta;
  NumericVector Sa;
  NumericVector Ia;
  NumericVector Ra;
  
  
  
  do{
    ta.push_back(t);
    Sa.push_back(S);
    Ia.push_back(I);
    Ra.push_back(R);
    
    double lambd = beta*(I+iota)/N;
    double ifrac = 1.0 -exp(-lambd);
    double rfrac = 1.0 - exp(-gamma);
    double  infection = as<double>(rbinom(1,S,ifrac));
    double recovery = as<double>(rbinom(1,I,rfrac));
    
    S-=infection;
    I= I +infection - recovery;
    R+= recovery;
    t++;
    
    if(initial == true){
      if(I==0){break;}
    }
    
  } while (t<=tf );
  
  NumericVector IR(Ia.size() + Ra.size()); // preallocate memory
  
  for(int i= 0; i < Ia.size(); i++ ){
    
    IR.insert(i,Ia[i]);
  }
  
  for(int i= 0; i < Ra.size(); i++ ){
    
    IR.insert(i+Ia.size(),Ra[i]);
  }
  // IR.insert( IR.end(), Ia.begin(), Ia.end() );
  // IR.insert( IR.end(), Ra.begin(), Ra.end() );
  
  // std::copy(Ia.begin(), Ia.end(), IR.begin() + index);
  
  //   X.push_back(IR);
  // } 
  
  
  return IR;
}
