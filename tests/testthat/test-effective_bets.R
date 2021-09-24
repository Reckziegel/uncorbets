# extract the invariants from the data
set.seed(123)
ret <- matrix(stats::rnorm(400), ncol = 4)
# calculate the covariance matrix
sigma <- stats::cov(ret)
# torsion
tmat <- torsion(sigma = sigma, model = 'minimum-torsion', method = 'exact')
#' # 1/N reference
prior_allocation <- rep(1 / ncol(ret), ncol(ret))

enb <- effective_bets(prior_allocation, sigma, tmat)

test_that("effective_bets()", {

  # overall structure
  expect_type(enb, "list")
  expect_length(enb, 2L)
  expect_named(enb, c("p", "enb"))

  # Portfolio Allocation
  expect_length(enb[[1]], 4L)
  expect_equal(sum(enb[[1]]), 1)
  expect_true(all(enb[[1]] > 0))

  # Number of Bets
  expect_length(enb[[2]], 1L)
  expect_true(enb[[2]] > 0 & enb[[2]] < ncol(ret))

})

test_that("effective_bets() error handling", {
  # b` must be univariate.
  expect_error(
    effective_bets(cbind(prior_allocation, prior_allocation), sigma, tmat)
  )
  # `sigma` matrix must be quadratic
  expect_error(
    effective_bets(prior_allocation, sigma[1:4, 1:3], tmat)
  )
})

