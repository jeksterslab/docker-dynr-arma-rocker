FROM rocker/tidyverse

RUN apt-get update -y && apt-get install -y \
        wget                                \
        vim                              && \
        install2.r --error \
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
        RcppGSL        \
        Ryacas         \
        testthat       \
        knitr          \
        rmarkdown   && \
        Rscript -e "remotes::install_version(                \
                package = 'roxygen2',                        \
                version = '5.0.1',                           \
                repos = c(CRAN = 'https://cran.rstudio.com') \
                );                                           \
                tinytex::install_tinytex()"               && \
        git clone -b arma https://github.com/mhunter1/dynr.git    && \
        cd dynr                                                   && \
        sed -i 's/library/site-library/g' src/Makevars.in         && \
        ./configure                                               && \
        make clean install                                        && \
        cd ..                                                     && \
        rm -rf dynr

# author
MAINTAINER "Ivan Jacob Agaloos Pesigan <learn.jeksterslab@gmail.com>"

# extra metadata
LABEL description="dynr-arma-rocker container."
