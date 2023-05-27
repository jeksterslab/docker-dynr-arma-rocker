FROM rocker/tidyverse

# apt
RUN apt-get update -y && apt-get install -y \
        wget                                \
        vim                                 \
        libopenblas-openmp-dev

# gsl
RUN wget https://ftp.gnu.org/gnu/gsl/gsl-2.7.tar.gz \
    && tar -zxvpf gsl-2.7.tar.gz                    \
    && cd gsl-2.7                                   \
    && ./configure                                  \
    && make                                         \
    && make install                                 \
    && cd ..                                        \
    && rm -rf gsl*

# armadillo
RUN wget https://sourceforge.net/projects/arma/files/armadillo-12.4.0.tar.xz \
    && tar -xvf armadillo-12.4.0.tar.xz                                      \
    && cd armadillo-12.4.0                                                   \
    && ./configure                                                           \
    && make                                                                  \
    && make install                                                          \
    && cd ..                                                                 \
    && rm -rf armadillo*

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

# dynr
RUN git clone https://github.com/mhunter1/dynr.git \
    && git checkout arma                           \
    && git pull --rebase                           \
    && cd dynr                                     \
    && ./configure                                 \
    && make clean install                          \
    && cd ..                                       \
    && rm -rf dynr

# author
MAINTAINER "Ivan Jacob Agaloos Pesigan <learn.jeksterslab@gmail.com>"

# extra metadata
LABEL description="dynr-arma-rocker container."
