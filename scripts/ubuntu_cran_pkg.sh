#!/bin/bash

set -e

install2.r --error --skipinstalled -n -1 \
  car            \
  deSolve        \
  devtools       \
  fda            \
  fds            \
  ggplot2        \
  knitr          \
  languageserver \
  latex2exp      \
  magrittr       \
  MASS           \
  Matrix         \
  mice           \
  numDeriv       \
  plyr           \
  Rcpp           \
  RcppArmadillo  \
  RcppGSL        \
  Rdpack         \
  remotes        \
  reshape2       \
  rmarkdown      \
  Ryacas         \
  stringi        \
  testthat       \
  tibble         \
  tinytex        \
  xtable

# rjags dependencies
install2.r --error --skipinstalled -n -1 \
    coda

# rjags
install2.r --error --skipinstalled -n -1 \
    rjags

R -e "library(rjags)"

echo -e "\nInstall rjags, done!"

# R2jags dependencies
install2.r --error --skipinstalled -n -1 \
    abind \
    coda \
    R2WinBUGS \
    stringr

# R2jags
install2.r --error --skipinstalled -n -1 \
    R2jags

R -e "library(R2jags)"

echo -e "\nInstall R2jags, done!"

# rstan dependencies
install2.r --error --skipinstalled -n -1 \
    StanHeaders                          \
    BH                                   \
    inline                               \
    gridExtra                            \
    Rcpp                                 \
    RcppEigen                            \
    RcppParallel                         \
    loo                                  \
    pkgbuild                             \
    QuickJSR

# rstan
install2.r --error --skipinstalled -n -1 \
    rstan

R -e "library(rstan)"

echo -e "\nInstall rstan, done!"

#!/bin/bash

set -e

# ctsem dependencies
install2.r --error --skipinstalled -n -1 \
    cOde                                 \
    data.table                           \
    Deriv                                \
    expm                                 \
    ggplot2                              \
    MASS                                 \
    Matrix                               \
    mize                                 \
    mvtnorm                              \
    plyr                                 \
    RcppParallel                         \
    rstan                                \
    rstantools                           \
    tibble                               \
    BH                                   \
    Rcpp                                 \
    RcppEigen                            \
    RcppParallel                         \
    StanHeaders

# ctsem
install2.r --error --skipinstalled -n -1 \
    ctsem

R -e "library(ctsem)"

echo -e "\nInstall ctsem, done!"

# vscode project dependencies
install2.r --error --skipinstalled -n -1 \
  languageserver \
  styler         \
  lintr

# removed from CRAN
# httpgd         \

# autoVAR dependencies
install2.r --error --skipinstalled -n -1 \
  qgraph \
  igraph \
  fclust

# simStateSpace
install2.r --error --skipinstalled -n -1 \
  simStateSpace

# bootStateSpace
install2.r --error --skipinstalled -n -1 \
  bootStateSpace

# cTMed
install2.r --error --skipinstalled -n -1 \
  cTMed
