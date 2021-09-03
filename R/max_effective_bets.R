#' Risk-Diversification powered by the Minimum Torsion Algorithm
#'
#' Finds the allocation that maximizes the \code{\link{effective_bets}}.
#'
#' @param x0 A \code{numeric} vector for the search starting point. Usually the
#' "one over n" allocation.
#' @param sigma A \code{n x n} covariance matrix.
#' @param t A \code{n x n} torsion matrix.
#' @param tol An \code{interger} with the convergence tolerance.
#' @param maxeval An \code{integer} with the maximum number of evaluations of the
#' objective function.
#' @param maxiter An \code{integer} with the maximum number of iterations.
#'
#' @return A \code{list} with the following components:
#'     \itemize{
#'       \item \code{weights}: the optimal allocation policy
#'       \item \code{enb}: the optimal effective number of bets
#'       \item \code{counts}: the number of iterations of the objective and the gradient
#'       \item \code{lambda_lb}: the lower bound Lagrange multipliers
#'       \item \code{lambda_ub}: the upper bound Lagrange multipliers
#'       \item \code{lambda_eq}: the equality Lagrange multipliers
#'       \item \code{gradient}: the gradient of the objective function at the optimum
#'       \item \code{hessian}: hessian of the objective function at the optimum
#'     }
#'
#' @export
#'
#' @seealso \code{\link[NlcOptim]{solnl}}
#'
#' @examples
#' # extract the invariants from the data
#' set.seed(123)
#' log_ret <- matrix(stats::rnorm(400), ncol = 4) / 10
#'
#' # compute the covariance matrix
#' sigma <- stats::cov(log_ret)
#'
#' # torsion
#' torsion_cov <- torsion(sigma = sigma, model = 'minimum-torsion', method = 'exact')
#'
#' # 1/N reference
#' b <- rep(1 / ncol(log_ret), ncol(log_ret))
#'
#' max_effective_bets(x0 = b, sigma = sigma, t = torsion_cov)
max_effective_bets <- function(x0,
                               sigma,
                               t,
                               tol     = 1e-20,
                               maxeval = 5000L,
                               maxiter = 5000L) {

  assertthat::assert_that(assertthat::is.number(tol))
  assertthat::assert_that(assertthat::is.number(maxeval))
  assertthat::assert_that(assertthat::is.number(maxiter))
  assertthat::assert_that(NCOL(sigma) == NCOL(t))

  size <- NCOL(sigma)
  if (is.null(x0)) {
    x0 <- rep(1 / size, size)
  }

  objective <- function(x0, sigma, t) {
    -effective_bets(b = x0, sigma = sigma, t = t)$enb
  }

  fun <- match.fun(objective)
  fn <- function(x) fun(x, sigma, t)

  opt <- NlcOptim::solnl(
    X       = x0,
    objfun  = fn,
    Aeq     = matrix(1, ncol = size),
    Beq     = 1,
    lb      = rep(0, size),
    ub      = rep(1, size),
    maxIter = maxiter,
    maxnFun = maxeval
  )

  out <- list(
    weights   = as.vector(opt$par),
    enb       = -opt$fn,
    counts    = opt$counts,
    lambda_lb = opt$lambda$lower,
    lambda_ub = opt$lambda$upper,
    lambda_eq = opt$lambda$eqlin,
    gradient  = opt$grad,
    hessian   = opt$hessian
  )

  if (is_col_named(sigma)) {
    nms <- colnames(sigma)
    rownames(out$lambda_lb) <- nms
    rownames(out$lambda_ub) <- nms
    rownames(out$gradient)  <- nms
    rownames(out$hessian)   <- nms
    colnames(out$hessian)   <- nms
  }

  out

}


