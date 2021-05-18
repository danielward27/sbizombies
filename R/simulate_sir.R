library(reshape2)
library(Rcpp)
library(ggplot2)


cppFunction('
            
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
  }')


# wrapper function

simulate_sir = function(theta,initial,N=1000,tf=20000){
  beta = theta[1]; gamma = theta[2]; iota = theta[3]; S0 = theta[4]
  I0 = N-S0; R0 = 0;
  
  sir_out_list = sirc(beta,gamma,iota,N,S0,I0,R0,tf,initial=initial)
  
  if(initial == T){
    sir_out <- as.data.frame(sir_out_list)
    
    
    sir_out_long <- melt(sir_out,"time")
    
    
    ggplot(sir_out_long,aes(x=time,y=value,colour=variable,group=variable))+
      # Add line
      geom_line(lwd=2)+
      #Add labels
      xlab("Time")+ylab("Number")
    
  }
  
  x_obs = rbind(as.matrix(sir_out_list$I),as.matrix(sir_out_list$R))
  
  return(t(x_obs))
  }


# example
#
# theta = c(0.1,0.05,0.1,999)
#
# x = simulate_sir(theta,initial=T,N=1000,tf=20000)
#
#
#



