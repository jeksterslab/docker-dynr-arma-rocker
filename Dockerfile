FROM rocker/rstudio:4.3.0
RUN /rocker_scripts/install_tidyverse.sh

ADD scripts /usr/src/local/src
RUN cd /usr/src/local/src     && \
    chmod 777 setup.sh        && \
    ./setup.sh                && \
    rm -rf /usr/src/local/src

ENV PATH="/opt/TinyTeX/bin/x86_64-linux:${PATH}"

# extra metadata
LABEL org.opencontainers.image.source="https://github.com/jeksterslab/dynr-arma-rocker" \
      org.opencontainers.image.authors="Ivan Jacob Agaloos Pesigan <learn.jeksterslab@gmail.com>"
