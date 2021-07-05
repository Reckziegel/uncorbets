#' Returns the square root of a symmetric positive definite matrix
#'
#' This function was copied and pasted from the \code{rrcov} package to avoid dependencies.
#'
#' @param A A square matrix
#'
#' @return A quadratic matrix.
#'
#' @keywords internal
sqrtm <- function(A) {

  if (!is.matrix(A) || ncol(A) != nrow(A))
    stop("The matrix A must be a square matrix\n", .call = FALSE)

  ee <- eigen(A)

  if (any(ee$values < 0)) {
    stop("The matrix A must be positive definite.", .call = FALSE)
  }
  ee$vectors %*% diag(sqrt(ee$values)) %*% t(ee$vectors)

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

