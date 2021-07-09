#' Computes the Minimum Torsion Matrix
#'
#' Computes the Principal Components Torsion and the Minimum Torsion
#' for diversification analysis.
#'
#' @param sigma A \code{n x n} covariance matrix.
#' @param model One of: "pca" or "minimum-torsion".
#' @param method One of: "approximate" or "exact". Only used when \code{model = "minimum-torsion"}.
#' @param max_niter An \code{integer} with the maximum number of iterations.
#'
#' @return A \code{n x n} torsion matrix.
#'
#' @export
#'
#' @examples
#' # extract the invariants from the data
#' set.seed(123)
#' log_ret <- matrix(rnorm(400), ncol = 4) / 10
#'
#' # calculate the covariance matrix
#' sigma <- stats::cov(log_ret)
#'
#' # torsion
#' torsion(sigma = sigma, model = 'minimum-torsion', method ='exact')
torsion <- function(sigma, model = "minimum-torsion", method = "exact", max_niter = 10000L) {

  if (!(model %in% c('pca', 'minimum-torsion'))) {
    stop("Model must one of: 'pca' or 'minimum-torsion'", call. = FALSE)
  }
  if (model == 'minimum-torsion') {
    if (!(method %in% c('exact', 'approximate'))) {
      stop("Method must be one of: 'approximate' or 'exact'", call. = FALSE)
    }
  }
  if (!is.numeric(max_niter)) {
    stop("max_ninter must be numeric", call. = FALSE)
  }
  if (length(max_niter) > 1) {
    stop("max_ninter must be of lengh one.", call. = FALSE)
  }

  # main algo
  if (model == "pca") {

    ## PCA Decomposition
    spectral_decomposition <- eigen(sigma)
    e      <- spectral_decomposition$vectors
    lambda <- spectral_decomposition$values

    flip       <- e[1, ] < 0
    e[ , flip] <- -e[ , flip]
    tmp        <- sort(lambda, decreasing = TRUE, index.return = TRUE)
    index      <- tmp$ix

    ## PCA torsion
    t <- t(e[ , index])

  } else if (model == 'minimum-torsion') {

    ## alt
    C <- stats::cov2cor(sigma)

    ## Correlation matrix
    .sigma <- diag(sigma) ^ (1 / 2)
    C <- diag(1 / .sigma) %*% sigma %*% diag(1 / .sigma)
    c <- sqrtm(C) ## Riccati root of C

    if (method == 'approximate') {

      t <- (diag(.sigma) %*% solve(c)) %*% diag(1 / .sigma)

    } else if (method == 'exact') {

      n_ <- ncol(sigma)

      ## initialize
      d <- rep(1, n_)
      f <- rep(0, max_niter)

      for (i in 1:max_niter) {
        U <- diag(d) %*% c %*% c %*% diag(d)
        u <- sqrtm(U)
        q <- solve(u) %*% (diag(d) %*% c)
        d <- diag(q %*% c)
        pi_ <- diag(d) %*% q ## perturbation
        f[i] <- norm(c - pi_, 'F')

        if (i > 1 && abs(f[i] - f[i - 1]) / f[i] / n_ <= 10 ^ -8) {

          f <- f[1:i]

          break

        } else if (i == max_niter && abs(f[max_niter] - f[max_niter - 1]) / f[max_niter] / n_ > 10 ^ -8) {

          warning("number of max iterations reached: n_iter = ", max_niter, immediate. = TRUE)

        }

      }

      x <- pi_ %*% solve(c)
      t <- diag(.sigma) %*% x %*% diag(1 / .sigma)

    }

  }

  if (is_col_named(sigma)) {
    colnames(t) <- colnames(sigma)
    rownames(t) <- colnames(sigma)
  }

  t

}
