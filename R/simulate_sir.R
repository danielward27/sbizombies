library(reshape2)
library(Rcpp)
library(ggplot2)




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




