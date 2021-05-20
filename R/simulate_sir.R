# library(reshape2)
# library(Rcpp)
# library(ggplot2)
# 
# 
# cppFunction('
#   List sirc(double beta, double gamma, double N, double tf){
#     
#     double S0 = N - 1;
#     double I0 = 1;
#     double R0 = 0;
#     
#     
#     double t = 0;
#     double S = S0;
#     double I = I0;
#     double R = R0;
#     std::vector<double> ta;
#     std::vector<double> Sa;
#     std::vector<double> Ia;
#     std::vector<double> Ra;
#     
#     do{
#       
#       // append the new populations to the vectors
#       
#       if(t>0){
#         ta.push_back(t);
#         Sa.push_back(S);
#         Ia.push_back(I);
#         Ra.push_back(R);}
#       
#       // calculate the updates
#       
#       double lambd = beta*I/N;
#       double ifrac = 1.0 -exp(-lambd);
#       double rfrac = 1.0 - exp(-gamma);
#       double  infection = as<double>(rbinom(1,S,ifrac));
#       double recovery = as<double>(rbinom(1,I,rfrac));
#       
#       // updates the populations
#       
#       S-=infection;
#       I= I +infection - recovery;
#       R+= recovery;
#       t++;
#       
#       // conditional break on initial run
#       
#       
#         if(I==0){break;
#       }
#       
#     } while (t<=tf && (I>0));
#   return List::create(_["time"] = ta, _["S"] = Sa, _["Z"] = Ia, _["R"]=Ra);
#   }'
# )
# 
# # wrapper function
# 
# 
# beta = 1.5;gamma=1.5;N=1000;tf=20000;
# 
# sir_out_list = sirc(beta,gamma,N,tf)
#   
# 
# sir_out <- as.data.frame(sir_out_list)
#     
#     
# sir_out_long <- melt(sir_out,"time")
#     
#     
# ggplot(sir_out_long,aes(x=time,y=value,colour=variable,group=variable))+
#       # Add line
#   geom_line(lwd=2)+
#       #Add labels
#   xlab("Time")+ylab("Number")
#     
#   
#   
# 
# 
# 
# 
# 
# x = simulate_sir(theta,initial=T,N=1000,tf=20000)
# 






