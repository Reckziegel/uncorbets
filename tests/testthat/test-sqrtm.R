# data
ret <- diff(log(EuStockMarkets))
ret_cov <- stats::cov(ret)
ds <- eigen(ret_cov)

# test
test_that("sqrtm uses spectral decomposition", {
  expect_equal(sqrtm(ret_cov), ds$vectors %*% diag(sqrt(ds$values)) %*% t(ds$vectors))
})
