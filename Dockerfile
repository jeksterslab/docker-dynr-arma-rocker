FROM rocker/tidyverse

# apt
RUN apt-get update -y && apt-get install -y \
        wget                                \
        vim                                 \
        build-essential                     \
        cmake                               \
        libopenblas-dev                     \
        liblapack-dev                       \
        libarpack2-dev                      \
        libsuperlu-dev                      \
        libarmadillo-dev                    \
        libgsl-dev

# install R packages
# dynr dependencies
# other useful packages
RUN install2.r --error \
        devtools       \
        remotes        \
        tinytex        \
        MASS           \
        Matrix         \
        numDeriv       \
        xtable         \
        latex2exp      \
        reshape2       \
        plyr           \
        mice           \
        magrittr       \
        fda            \
        car            \
        stringi        \
        tibble         \
        deSolve        \
        Rdpack         \
        Rcpp           \
        RcppArmadillo  \
        testthat       \
        knitr          \
        rmarkdown

# to build documentation
RUN Rscript -e "remotes::install_version(package = 'roxygen2', version = '5.0.1', repos = c(CRAN = 'https://cran.rstudio.com')); tinytex::install_tinytex()"

# author
MAINTAINER "Ivan Jacob Agaloos Pesigan <learn.jeksterslab@gmail.com>"

# extra metadata
LABEL description="dynr-arma-rocker container."
