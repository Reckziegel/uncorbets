# data
mtx_quad <- matrix(4, 2, 2)
mtx_non_quad <- matrix(4, 4, 1)

# test
test_that("is_quadratic() returns a flag", {
  expect_type(is_quadratic(mtx_quad), "logical")
  expect_true(is_quadratic(mtx_quad))
  expect_false(is_quadratic(mtx_non_quad))
})
