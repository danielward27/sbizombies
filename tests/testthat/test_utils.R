
s = matrix(runif(1000), 100, 10)

test_that("Scaler", {
  # test scaler on matrix
  m_sd = mean_and_sd(s)
  s_scaled = scaler(s, m_sd)
  expect_equal(colMeans(s_scaled), rep(0, 10))
  expect_equal(apply(s_scaled, 2, sd), rep(1, 10))
  
  # test scaler on vector
  s_obs = rep(0, 10)
  s_scaled = scaler(s_obs, m_sd)
  all.equal(s_scaled, -(m_sd$mean)/m_sd$sd)
})
