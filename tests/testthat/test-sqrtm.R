# data
set.seed(123)
ret <- matrix(stats::rnorm(400), ncol = 4)
ret_cov <- stats::cov(ret)
ds <- eigen(ret_cov)

# test
test_that("sqrtm uses spectral decomposition", {
  expect_equal(sqrtm(ret_cov), ds$vectors %*% diag(sqrt(ds$values)) %*% t(ds$vectors))
})

test_that("sqrtm only work with quadratic objects", {
  expect_error(sqrtm(matrix(stats::rnorm(6), ncol = 2)))
})
