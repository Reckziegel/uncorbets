#' Effective Number of Bets
#'
#' Computes the diversification probability distribution and the effective number
#' of bets of an allocation.
#'
#' @param b A vector of exposures (allocations).
#' @param sigma A \code{n x n} covariance matrix.
#' @param t A \code{n x n} torsion matrix.
#'
#' @return A \code{list} of length 2 with:
#'     \itemize{
#'       \item \code{p}: the diversification probability distribution;
#'       \item \code{enb}: the effective number of bets.
#'     }
#'
#' @export
#'
#' @examples
#' # extract the invariants from the data
#' log_ret <- diff(log(EuStockMarkets))
#'
#' # compute the covariance matrix
#' sigma <- stats::cov(log_ret)
#'
#' # torsion
#' torsion_cov <- torsion(sigma = sigma, model = 'minimum-torsion', method ='exact')
#'
#' # 1/N reference
#' b <- rep(1 / ncol(log_ret), ncol(log_ret))
#'
#' # ENB
#' effective_bets(b = b, sigma = sigma, t = torsion_cov)
effective_bets <- function(b, sigma, t) {

  if (NCOL(b) > 1) {
    stop("`b` must be univariate.", call. = FALSE)
  }
  if (!is_quadratic(sigma)) {
    stop("`sigma` matrix must be quadratic.", call. = FALSE)
  }

  p <- solve(t(t), b) * (t %*% sigma %*% b) / as.numeric((t(b) %*% sigma %*% b))
  enb <- exp(-sum(p * log(1 + (p - 1) * (p > 1e-5))))

  out <- list(p = p, enb = enb)
  out

}
