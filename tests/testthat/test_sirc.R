# Tests can be run with ctrl + shift + t

test_that("Testing simulation 'szr' rcpp function outputs correct dimension on training run?", {

  tf = 50
  nruns = 3
  
  theta = matrix(runif(nruns*2),nrow=nruns)
  X = szr(theta,1000,tf,initial = F)
  
  expect_equal(c(nruns,2*tf),dim(X))
})


test_that("Testing simulation 'szr' rcpp function outputs correct dimension on initial run?", {
  
  tf = 500

  theta = matrix(c(0.1,0.05),nrow=1)
  X = szr(theta,1000,tf,initial = T)
  
  expect_equal(1,dim(X)[1])
})