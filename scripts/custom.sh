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
        repos = 'https://packagemanager.rstudio.com/all/__linux__/noble/latest', \
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
wget https://raw.githubusercontent.com/ijapesigan/rProject/main/project.Rproj
echo "session-default-working-dir=/home/${DEFAULT_USER}/working-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/working-dir"

## project folder
mkdir -p "/home/${DEFAULT_USER}/project-dir"
cd "/home/${DEFAULT_USER}/project-dir"
echo "session-default-new-project-dir=/home/${DEFAULT_USER}/project-dir" >> /etc/rstudio/rsession.conf
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/project-dir"

# build

GIT_HUB_USERNAME=mhunter1
GIT_HUB_REPO=dynr
GIT_HUB_BRANCH=arma
DOCKER_HUB_USERNAME=jeksterslab
DOCKER_HUB_CONTAINER=dynr-arma-rocker

## container
TEMP_VAR=$(git ls-remote "https://github.com/$GIT_HUB_USERNAME/$GIT_HUB_REPO".git "$GIT_HUB_BRANCH")
echo "$TEMP_VAR" > /etc/profile.d/container_init.sh
awk '{print $1 > "/etc/profile.d/container_init.sh"}' /etc/profile.d/container_init.sh
CONTAINER_RELEASE=$(cat /etc/profile.d/container_init.sh)
echo "export CONTAINER_RELEASE=$CONTAINER_RELEASE" > /etc/profile.d/container_init.sh
CONTAINER_RELEASE_MSG="\"This release is based on commit $CONTAINER_RELEASE.\""
echo "export CONTAINER_RELEASE_MSG=$CONTAINER_RELEASE_MSG" >> /etc/profile.d/container_init.sh

{
  echo "export GIT_HUB_USERNAME=$GIT_HUB_USERNAME"
  echo "export GIT_HUB_REPO=$GIT_HUB_REPO"
  echo "export GIT_HUB_BRANCH=$GIT_HUB_BRANCH"
  echo "export DOCKER_HUB_USERNAME=$DOCKER_HUB_USERNAME"
  echo "export DOCKER_HUB_CONTAINER=$DOCKER_HUB_CONTAINER"
} >> /etc/profile.d/container_init.sh

## srv
mkdir -p /srv/build

## container
touch /srv/build/CONTAINER_RELEASE_MSG
touch /srv/build/CONTAINER_RELEASE
echo "$CONTAINER_RELEASE_MSG" > /srv/build/CONTAINER_RELEASE_MSG
sed -i s/\"//g /srv/build/CONTAINER_RELEASE_MSG
echo "$CONTAINER_RELEASE" > /srv/build/CONTAINER_RELEASE

## github
touch /srv/build/GIT_HUB_USERNAME
touch /srv/build/GIT_HUB_REPO
echo "$GIT_HUB_USERNAME" > /srv/build/GIT_HUB_USERNAME
echo "$GIT_HUB_REPO" > /srv/build/GIT_HUB_REPO

## docker
touch /srv/build/DOCKER_HUB_USERNAME
touch /srv/build/DOCKER_HUB_CONTAINER
echo "$DOCKER_HUB_USERNAME" > /srv/build/DOCKER_HUB_USERNAME
echo "$DOCKER_HUB_CONTAINER" > /srv/build/DOCKER_HUB_CONTAINER
