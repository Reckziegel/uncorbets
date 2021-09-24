
<!-- README.md is generated from README.Rmd. Please edit that file -->

# uncorbets

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/Reckziegel/uncorbets/branch/main/graph/badge.svg)](https://codecov.io/gh/Reckziegel/uncorbets?branch=main)
[![R-CMD-check](https://github.com/Reckziegel/uncorbets/workflows/R-CMD-check/badge.svg)](https://github.com/Reckziegel/uncorbets/actions)

<!-- badges: end -->

The Euler theorem has been widely used in finance as a way to decompose
homogeneous risk measures of degree one. Unfortunately, this
decomposition does not isolate the true sources of risk.

The Minimum Torsion Bets (MTB) offers a solution to this problem: it
uses the spectral decomposition to “pick” the uncorrelated factors that
are as close as possible to the original variables, among all living
matrix rotations.

The output is a diversification distribution with the following
properties: it’s always positive, sums to 1, capture the true sources
risk and have an insightful interpretation. The above characteristics
put the Effective Number of Minimum Torsion Bets as a generalization of
the Marginal Contribution to Risk (MCR).

## Example

``` r
library(uncorbets)

# prepare data
returns <- diff(log(EuStockMarkets))
covariance <- cov(returns)

# Minimum Torsion Matrix
torsion_mat <- torsion(covariance)

# Prior Allocation (equal weights, for example)
w <- rep(1 / ncol(returns), ncol(returns))

# Compute diversification distribution and the diversification level
effective_bets(b = w, sigma = covariance, t = torsion_mat)
#> $p
#>           [,1]
#> DAX  0.2673005
#> SMI  0.2404370
#> CAC  0.2776369
#> FTSE 0.2146256
#> 
#> $enb
#> [1] 3.980549
# maximize the effective number of bets (enb)
max_effective_bets(x0 = w, sigma = covariance, t = torsion_mat)
#> $weights
#> [1] 0.2227163 0.2603372 0.2114589 0.3054876
#> 
#> $enb
#> [1] 4
#> 
#> $counts
#>      nfval ngval
#> [1,]    47     9
#> 
#> $lambda_lb
#>      [,1]
#> DAX     0
#> SMI     0
#> CAC     0
#> FTSE    0
#> 
#> $lambda_ub
#>      [,1]
#> DAX     0
#> SMI     0
#> CAC     0
#> FTSE    0
#> 
#> $lambda_eq
#> [1] 1.162481e-06
#> 
#> $gradient
#>               [,1]
#> DAX   1.966953e-06
#> SMI  -4.768372e-06
#> CAC   8.940697e-06
#> FTSE -3.337860e-06
#> 
#> $hessian
#>             DAX        SMI        CAC       FTSE
#> DAX   5.3149468 -1.4603802 -1.4893686 -0.5169268
#> SMI  -1.4603802  5.2212615 -3.6528175 -0.9075766
#> CAC  -1.4893686 -3.6528175  6.3451210 -0.5218244
#> FTSE -0.5169268 -0.9075766 -0.5218244  7.6046588
```

## Installation

Install the released version from CRAN with:

``` r
install.packages("uncorbets")
```

Install the development version of `uncorbets` from github with:

``` r
# install.packages("devtools")
devtools::install_github("Reckziegel/uncorbets")
```

## References

-   Meucci, Attilio and Santangelo, Alberto and Deguest, Romain, Risk
    Budgeting and Diversification Based on Optimized Uncorrelated
    Factors (November 10, 2015). Available at SSRN:
    <https://www.ssrn.com/abstract=2276632> or
    <http://dx.doi.org/10.2139/ssrn.2276632>

-   Attilio Meucci (2021). Portfolio Diversification Based on Optimized
    Uncorrelated Factors
    (<https://www.mathworks.com/matlabcentral/fileexchange/43245-portfolio-diversi-cation-based-on-optimized-uncorrelated-factors>),
    MATLAB Central File Exchange. Retrieved July 8, 2021.
