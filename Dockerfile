FROM rocker/rstudio:latest

RUN /rocker_scripts/install_texlive.sh

ADD scripts /usr/src/local/src
RUN cd /usr/src/local/src     && \
    chmod 777 setup.sh        && \
    ./setup.sh                && \
    rm -rf /usr/src/local/src

# extra metadata
LABEL org.opencontainers.image.source="https://github.com/jeksterslab/dynr-arma-rocker" \
      org.opencontainers.image.authors="Ivan Jacob Agaloos Pesigan <learn.jeksterslab@gmail.com>"
