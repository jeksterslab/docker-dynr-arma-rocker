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

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm -rf lazygit*

# pfetch
git clone https://github.com/dylanaraps/pfetch.git
install pfetch/pfetch /usr/local/bin/
ls -l /usr/local/bin/pfetch

# dynr deps
apt_install                \
    libcurl4-openssl-dev   \
    libharfbuzz-dev        \
    libfribidi-dev         \
    libfontconfig1-dev     \
    build-essential        \
    cmake                  \
    libopenblas-dev        \
    liblapack-dev          \
    libarpack2-dev         \
    libsuperlu-dev         \
    libgsl-dev             \
    libarmadillo-dev       \
    libeigen3-dev

# qgraph
apt_install   \
  libglpk-dev
