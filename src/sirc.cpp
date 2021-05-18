#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix sirc(NumericMatrix theta, double N, double S0, double I0, double R0, double tf, bool initial = true){
  
  
  int Nruns = theta.nrow();
  
  NumericVector IR;
  
  NumericMatrix X(Nruns, 2*tf);
  
  int n;

  for (int i = 0; i < Nruns; i++){
  
    double beta = theta(i,0);
    double gamma = theta(i,1);
    double iota = theta(i,2);
  
    double t = 1;
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
  
    for(int j= 0; j < Ra.size(); j++ ){
  
      IR.insert(j+Ia.size(),Ra[j]);
    }
    
    std::cout<<Ia.size()<<std::endl;
    std::cout<<Ra.size()<<std::endl;
      
    
    X(i,_) =  IR[Range(0,2*Ia.size())];
    
    n = 2*Ia.size();
  
    }

    std::cout<<n<<std::endl;
  return X(_,Range(0,n-1));
}
