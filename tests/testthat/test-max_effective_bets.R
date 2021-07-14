ret <- diff(log(EuStockMarkets))
sig <- stats::cov(ret)
tcov <- torsion(sigma = sig, model = 'minimum-torsion', method = 'exact')
x0 <- rep(1 / ncol(ret), ncol(ret))
opt <- max_effective_bets(x0 = x0, sigma = sig, t = tcov)

test_that("max_effective_bets works", {
  # type and length
  expect_type(opt, "list")
  expect_true(all(sapply(opt, is.numeric)))
  expect_length(opt, 8L)
  # names
  expect_named(opt, c("weights", "enb", "counts", "lambda_lb", "lambda_ub", "lambda_eq", "gradient", "hessian"))
})
