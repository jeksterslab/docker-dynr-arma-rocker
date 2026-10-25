#!/bin/bash

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

# rProject
apt_install                    \
    libcurl4-openssl-dev       \
    libxml2-dev                \
    libssl-dev                 \
    libfontconfig1-dev         \
    libharfbuzz-dev            \
    libfribidi-dev             \
    libgit2-dev                \
    libfreetype-dev            \
    libpng-dev                 \
    libtiff5-dev               \
    libjpeg-dev
