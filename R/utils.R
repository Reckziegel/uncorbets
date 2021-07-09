#' MATLAB `sqrtm` functionality
#'
#' This function returns the square root of a quadratic matrix.
#'
#' @param A A square matrix.
#'
#' @return A squared \code{matrix}.
#'
#' @keywords internal
sqrtm <- function(x) {
  if (!is_quadratic(x))
    stop("The object `x` is not quadratic.", .call = FALSE)
  eig <- eigen(x)
  if (any(eig$values < 0)) {
    stop("The object `x` is not positive definite.", .call = FALSE)
  }
  eig$vectors %*% diag(sqrt(eig$values)) %*% t(eig$vectors)
}

#' Test if an object is quadratic
#'
#' @param x An object to be tested.
#'
#' @return A flag (`TRUE` or `FALSE`)
#'
#' @keywords internal
is_quadratic <- function(x) {
  NROW(x) == NCOL(x)
}

#' Test if an object has is named
#'
#' @param x The object to be tested.
#'
#' @return A flag (`TRUE` or `FALSE`)
#'
#' @keywords internal
is_col_named <- function(x) {
  nms <- colnames(x)
  if (is.null(nms)) FALSE else TRUE
}

