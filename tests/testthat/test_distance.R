# Tests can be run with ctrl + shift + t

test_that("Does the 'distance' rcpp function work?", {
  A = matrix(rnorm(100),10,10)
  b = rnorm(10)
  our_fnc = distance(A, b)
  R_fnc <- dist(rbind(A[1,],b))
  
  expect_equal(as.numeric(our_fnc[1]), as.numeric(R_fnc))
})
