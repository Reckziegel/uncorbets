#' Effective Number of Bets
#'
#' Computes the diversification probability distribution and the effective number
#' of bets an allocation.
#'
#' @param b A vector of exposures.
#' @param sigma A \code{n x n} covariance matrix.
#' @param t A \code{n x n} torsion matrix.
#'
#' @return A \code{list} with the effective number of bets - enb - and the diversification probability distribution - p.
#'
#' @details Transcripted from the MATLAB code in \url{https://la.mathworks.com/matlabcentral/fileexchange/43245-portfolio-diversi-cation-based-on-optimized-uncorrelated-factors?s_tid=prof_contriblnk}.
#'
#' @seealso A. Meucci, A. Santangelo, R. Deguest - "Measuring Portfolio Diversification Based on Optimized Uncorrelated Factors" (2013)
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
#' torsion_cov <- torsion(Sigma = sigma, model = 'minimum-torsion', method ='exact')
#'
#' # 1/N reference
#' b <- rep(1 / ncol(log_ret), ncol(log_ret))
#'
#' # ENB
#' effective_bets(b = b, sigma = sigma, t = torsion_cov)
effective_bets <- function(b, sigma, t) {

  if (NCOL(b) > 1) {
    stop("b must be univariate.", call. = FALSE)
  }
  if (!is_quadratic(sigma)) {
    stop("Sigma matrix must be quadratic", call. = FALSE)
  }

  p <- solve(t(t), b) * (t %*% sigma %*% b) / as.numeric((t(b) %*% sigma %*% b))
  enb <- exp(-sum(p * log(1 + (p - 1) * (p > 1e-5))))

  out <- list(allocation = p, enb = enb)
  out

}
