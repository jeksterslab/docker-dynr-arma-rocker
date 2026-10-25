#!/bin/bash

set -e

install2.r --error --skipinstalled -n -1 \
    BiocManager \
    cffr        \
    covr        \
    devtools    \
    distro      \
    knitr       \
    lintr       \
    pak         \
    pkgdown     \
    quarto      \
    Rcpp        \
    remotes     \
    rmarkdown   \
    roxygen2    \
    rprojroot   \
    stats       \
    styler      \
    tinytex     \
    utils       \
    testthat

R -e "remotes::install_github(      \
    c(                              \
        'ijapesigan/rProject'       \
    )                               \
)"

R -e "library(rProject)"

echo -e "\nInstall rProject, done!"
