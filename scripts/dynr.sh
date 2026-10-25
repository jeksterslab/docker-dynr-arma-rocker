#!/bin/bash

set -e

# dynr from GitHub (branch arma, built from source). Its R
# dependencies, Suggests included, come from its DESCRIPTION; its system
# libraries from apt.txt
git clone -b arma https://github.com/mhunter1/dynr.git

# the arma branch's Makevars expect these in R's own library
R -e "install.packages(c('Rcpp', 'RcppArmadillo', 'RcppGSL'), lib = file.path(Sys.getenv('R_HOME'), 'library'))"

Rscript -e "remotes::install_deps('dynr', dependencies = TRUE, upgrade = 'never')"
cd dynr
./configure
make clean install
cd ..
rm -rf dynr

R -e "library(dynr)"

echo -e "\nInstall dynr, done!"
