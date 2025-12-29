FROM rocker/rstudio:latest

# RUN echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/latest"))' >>"${R_HOME}/etc/Rprofile.site"

ADD scripts /usr/src/local/src
RUN cd /usr/src/local/src      && \
    chmod 0755 setup.sh        && \
    ./setup.sh                 && \
    rm -rf /usr/src/local/src

ENV PATH="/opt/TinyTeX/bin/x86_64-linux:/opt/TinyTeX/bin/aarch64-linux:${PATH}"

# extra metadata
LABEL org.opencontainers.image.source="https://github.com/jeksterslab/dynr-arma-rocker" \
      org.opencontainers.image.authors="Ivan Jacob Agaloos Pesigan <learn.jeksterslab@gmail.com>"
