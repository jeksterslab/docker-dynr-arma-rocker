FROM rocker/tidyverse

RUN apt-get update -y && apt-get install -y \
        wget                                \
        vim                                 \
        build-essential                     \
        cmake                               \
        libopenblas-dev                     \
        liblapack-dev                       \
        libarpack2-dev                      \
        libsuperlu-dev                      \
        libgsl-dev                          \
        libarmadillo-dev                 && \
        Rscript -e "install.packages(   \
                c(                      \
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
              ),                        \
              repos = 'https://packagemanager.rstudio.com/all/__linux__/jammy/latest', \
              lib = '/usr/local/lib/R/library'                                         \
        )"                                                                          && \
        Rscript -e "remotes::install_version(                         \
                        package = 'roxygen2',                         \
                        version = '5.0.1',                            \
                        repos = c(CRAN = 'https://cran.rstudio.com'), \
                        lib = '/usr/local/lib/R/library'              \
                );                                                    \
                tinytex::install_tinytex()"                        && \
        git clone -b arma https://github.com/mhunter1/dynr.git     && \
        cd dynr                                                    && \
        ./configure                                                && \
        make clean install                                         && \
        cd ..                                                      && \
        rm -rf dynr

# author
MAINTAINER "Ivan Jacob Agaloos Pesigan <learn.jeksterslab@gmail.com>"

# extra metadata
LABEL description="dynr-arma-rocker container."
