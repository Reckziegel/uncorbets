
<!-- README.md is generated from README.Rmd. Please edit that file -->

# uncorbets

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/Reckziegel/uncorbets/branch/main/graph/badge.svg)](https://codecov.io/gh/Reckziegel/uncorbets?branch=main)
[![R-CMD-check](https://github.com/Reckziegel/uncorbets/workflows/R-CMD-check/badge.svg)](https://github.com/Reckziegel/uncorbets/actions)
[![Travis build
status](https://travis-ci.com/Reckziegel/uncorbets.svg?branch=main)](https://travis-ci.com/Reckziegel/uncorbets)
<!-- badges: end -->

The Euler theorem has been widely used in finance as a way to decompose
homogeneous risk measures of degree one. Unfortunately, this
decomposition is spurious because all shocks are considered at once,
instead of been treated as independent sources of risk.

The Minimum Torsion Bets (MTB) offers a solution to this problem: it
uses the spectral decomposition to “pick” the uncorrelated factors that
are as close as possible to the original ones, among all the possible
rotations that live in the N-th dimensional space.

The output is a diversification distribution that it’s always positive,
sum to 1, capture the true sources risk and have a meaningful
interpretation. The above properties classify the Effective Number of
Minimum Torsion Bets a generalization of Marginal Contribution to Risk
(MCR).

## Toy Example

``` r
library(uncorbets)

# prepare data
returns <- diff(log(EuStockMarkets))
covariance <- cov(returns)
# Minimum Torsion Matrix
torsion_mat <- torsion(covariance)
# Prior Allocation (equal weights, for example)
w <- rep(1 / ncol(returns), ncol(returns))

# Compute allocation and diversification level
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
```

## Installation

Install the released version from CRAN with:

``` r
install.packages("uncorbets)
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
