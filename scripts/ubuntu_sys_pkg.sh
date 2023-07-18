#!/bin/bash

# based on https://raw.githubusercontent.com/rocker-org/rocker-versioned2/master/scripts/install_tidyverse.sh

set -e

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install                    \
    libxml2-dev                \
    libcairo2-dev              \
    libgit2-dev                \
    default-libmysqlclient-dev \
    libpq-dev                  \
    libsasl2-dev               \
    libsqlite3-dev             \
    libssh2-1-dev              \
    libxtst6                   \
    libcurl4-openssl-dev       \
    libharfbuzz-dev            \
    libfribidi-dev             \
    libfreetype6-dev           \
    libpng-dev                 \
    libtiff5-dev               \
    libjpeg-dev                \
    unixodbc-dev

# personal apt packages
apt_install        \
    bat            \
    curl           \
    git            \
    less           \
    nnn            \
    openssh-server \
    parallel       \
    rsync          \
    tmux           \
    vim            \
    wget

# dynr deps

# git
apt_install \
    git

# curl
apt_install \
    libcurl4-openssl-dev

# freetype2
apt_install            \
    libfontconfig1-dev \
    libfreetype6-dev   \
    libjpeg-dev        \
    libpng-dev         \
    libtiff5-dev

# nloptr
apt_install \
    cmake

# openssl
apt_install \
    libssl-dev

# systemfonts
apt_install \
    libfontconfig1-dev

# textshaping
apt_install         \
    libfribidi-dev  \
    libharfbuzz-dev

# xml2
apt_install \
    libxml2-dev

# gsl
apt_install \
    libgsl-dev

# misc3d
apt_install    \
    tcl8.6-dev \
    tk8.6-dev

# qgraph
apt_install   \
  libglpk-dev
