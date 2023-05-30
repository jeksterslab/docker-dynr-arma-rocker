#!/bin/bash

set -e

## build ARGs
NCPUS=${NCPUS:--1}

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install           \
    wget              \
    vim               \
    build-essential   \
    cmake             \
    libopenblas-dev   \
    liblapack-dev     \
    libarpack2-dev    \
    libsuperlu-dev    \
    libgsl-dev        \
    libarmadillo-dev

R -e "                                                    \
    .libPaths('/usr/local/lib/R/library');                \
    Sys.setenv(R_LIBS_USER = '/usr/local/lib/R/library'); \
    install.packages(        \
        c(                   \
            'devtools',      \
            'remotes',       \
            'tinytex',       \
            'MASS',          \
            'Matrix',        \
            'numDeriv',      \
            'xtable',        \
            'latex2exp',     \
            'reshape2',      \
            'plyr',          \
            'mice',          \
            'magrittr',      \
            'fda',           \
            'car',           \
            'stringi',       \
            'tibble',        \
            'deSolve',       \
            'Rdpack',        \
            'Rcpp',          \
            'RcppArmadillo', \
            'RcppGSL',       \
            'Ryacas',        \
            'testthat',      \
            'knitr',         \
            'rmarkdown'      \
        ),                   \
        repos = 'https://packagemanager.rstudio.com/all/__linux__/jammy/latest', \
        lib = '/usr/local/lib/R/library'                                         \
    )                                                                            \
"

R -e "                                                    \
    .libPaths('/usr/local/lib/R/library');                \
    Sys.setenv(R_LIBS_USER = '/usr/local/lib/R/library'); \
    remotes::install_version(                             \
        package = 'roxygen2',                             \
        version = '5.0.1',                                \
        repos = c(CRAN = 'https://cran.rstudio.com'),     \
        lib = '/usr/local/lib/R/library'                  \
    );                                                    \
    tinytex::install_tinytex()                            \
"

git clone -b arma https://github.com/mhunter1/dynr.git
cd dynr
./configure
make clean install
cd ..
rm -rf dynr

R -e "                                                                         \
    .libPaths(c('/usr/local/lib/R/site-library', '/usr/local/lib/R/library')); \
    Sys.setenv(R_LIBS_USER = '/usr/local/lib/R/site-library')                  \
"

# Directories
DEFAULT_USER=${DEFAULT_USER:-"rstudio"}

## working directory folder
mkdir -p /home/${DEFAULT_USER}/working-dir
cd /home/${DEFAULT_USER}/working-dir
wget https://raw.githubusercontent.com/jeksterslab/template/main/project.Rproj
echo "session-default-working-dir=/home/${DEFAULT_USER}/working-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/working-dir"

## project folder
mkdir -p /home/${DEFAULT_USER}/project-dir
cd /home/${DEFAULT_USER}/project-dir
echo "session-default-new-project-dir=/home/${DEFAULT_USER}/project-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/project-dir"

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

## Strip binary installed libraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so

# Installation information
echo -e "Session information...\n"
R -q -e "sessionInfo()"

# Check dynr
echo -e "Check the dynr package...\n"
R -q -e "library(dynr)"
echo -e "\nInstall dynr package, done!"
