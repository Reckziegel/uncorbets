# extract the invariants from the data
ret <- diff(log(EuStockMarkets))
# calculate the covariance matrix
sigma <- stats::cov(ret)
# torsion
tmat <- torsion(Sigma = sigma, model = 'minimum-torsion', method = 'exact')
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
