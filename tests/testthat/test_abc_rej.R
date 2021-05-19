
test_that("abc_rej", {
  prior = matrix(runif(10000), 1000, 10)
  s = matrix(runif(5000), 1000, 5)
  result = abc_rej(prior, s, runif(5))
  expect_equal(dim(result$posterior), c(10,10))
  expect_equal(dim(result$s), c(10,5))
})
