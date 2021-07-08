ret <- diff(log(EuStockMarkets))
sig <- cov(ret)

torsion_pca <- torsion(sigma = sig, model = "pca")
torsion_mt_approx <- torsion(sigma = sig, model = "minimum-torsion", method = "approximate")
torsion_mt_exact <- torsion(sigma = sig, model = "minimum-torsion", method = "exact")

test_that("torsion works on pca", {
  expect_type(torsion_pca, "double")
  expect_equal(nrow(torsion_pca), 4L)
  expect_equal(ncol(torsion_pca), 4L)
  expect_equal(rownames(torsion_pca), colnames(ret))
  expect_equal(colnames(torsion_pca), colnames(ret))
})

test_that("torsion works on mt-aprox", {
  expect_type(torsion_mt_approx, "double")
  expect_equal(nrow(torsion_mt_approx), 4L)
  expect_equal(ncol(torsion_mt_approx), 4L)
  expect_equal(rownames(torsion_mt_approx), colnames(ret))
  expect_equal(colnames(torsion_mt_approx), colnames(ret))
})

test_that("torsion works on mt-exact", {
  expect_type(torsion_mt_exact, "double")
  expect_equal(nrow(torsion_mt_exact), 4L)
  expect_equal(ncol(torsion_mt_exact), 4L)
  expect_equal(rownames(torsion_mt_exact), colnames(ret))
  expect_equal(colnames(torsion_mt_exact), colnames(ret))
})

test_that("outputs are different", {
  expect_true(all(torsion_mt_approx != torsion_mt_exact))
  expect_true(all(torsion_mt_approx != torsion_pca))
})
