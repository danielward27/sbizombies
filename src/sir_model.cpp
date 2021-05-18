#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List sirc(double beta, double gamma, double iota, double N, double S0, double I0, double R0, double tf, bool initial){
  
  double t = 0;
  double S = S0;
  double I = I0;
  double R = R0;
  std::vector<double> ta;
  std::vector<double> Sa;
  std::vector<double> Ia;
  std::vector<double> Ra;
  
  
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
  return List::create(_["time"] = ta, _["S"] = Sa, _["I"] = Ia, _["R"]=Ra);
}
