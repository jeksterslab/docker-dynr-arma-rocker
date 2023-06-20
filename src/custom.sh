#!/bin/bash

set -e

# Solution to hard-coded Makevars in the arma branch
R -e "                      \
    install.packages(       \
        c(                  \
          'Rcpp',           \
          'RcppArmadillo',  \
          'RcppGSL'         \
        ),                  \
        repos = 'https://packagemanager.rstudio.com/all/__linux__/jammy/latest', \
        lib = file.path(Sys.getenv('R_HOME'), 'library')                         \
    )                                                                            \
"

# Solution to documentation issues
R -e "                                                    \
    remotes::install_version(                             \
        package = 'roxygen2',                             \
        version = '5.0.1',                                \
        repos = c(CRAN = 'https://cran.rstudio.com')      \
    )                                                     \
"

# dynr
git clone -b arma https://github.com/mhunter1/dynr.git
cd dynr
./configure
make clean install
cd ..
rm -rf dynr

# Directories
DEFAULT_USER=${DEFAULT_USER:-"rstudio"}

## working directory folder
mkdir -p "/home/${DEFAULT_USER}/working-dir"
cd "/home/${DEFAULT_USER}/working-dir"
wget https://raw.githubusercontent.com/jeksterslab/template/main/project.Rproj
echo "session-default-working-dir=/home/${DEFAULT_USER}/working-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/working-dir"

## project folder
mkdir -p "/home/${DEFAULT_USER}/project-dir"
cd "/home/${DEFAULT_USER}/project-dir"
echo "session-default-new-project-dir=/home/${DEFAULT_USER}/project-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/project-dir"

## build
TEMP_VAR="$(git ls-remote https://github.com/mhunter1/dynr.git arma)"
echo "$TEMP_VAR" > /etc/profile.d/container_init.sh
awk '{print $1 > "/etc/profile.d/container_init.sh"}' /etc/profile.d/container_init.sh
CONTAINER_RELEASE=$(cat /etc/profile.d/container_init.sh)
echo "export CONTAINER_RELEASE=$CONTAINER_RELEASE" > /etc/profile.d/container_init.sh
CONTAINER_RELEASE_MSG="\"This release is based on commit $CONTAINER_RELEASE.\""
echo "export CONTAINER_RELEASE_MSG=$CONTAINER_RELEASE_MSG" >> /etc/profile.d/container_init.sh

mkdir -p /srv/build
touch /srv/build/CONTAINER_RELEASE_MSG
touch /srv/build/CONTAINER_RELEASE
echo "$CONTAINER_RELEASE_MSG" > /srv/build/CONTAINER_RELEASE_MSG
sed -i s/\"//g /srv/build/CONTAINER_RELEASE_MSG
echo "$CONTAINER_RELEASE" > /srv/build/CONTAINER_RELEASE
