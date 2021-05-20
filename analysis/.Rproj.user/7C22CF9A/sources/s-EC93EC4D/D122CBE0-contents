devtools::load_all("..")

set.seed(2)
i = 1
while (i <= 100){
  theta = t(c(beta = runif(1, 0, 3), gamma = runif(1, 0, 3)))
  result = szr(theta, N = 1000, tf = 500)[1, ]

  if (length(result) > 10 & length(result < 100)){
    pod_theta_filename = paste0("pods/pod_theta_", i, ".txt")
    pod_s_filename = paste0("pods/pod_s_", i, ".txt")
    
    ?tryCatch
    
    write.table(theta, file = pod_theta_filename, row.names = FALSE, col.names = FALSE)
    write.table(result, file = pod_s_filename, row.names = FALSE, col.names = FALSE)
    i = i+1
  }
}

