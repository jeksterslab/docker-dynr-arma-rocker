#!/bin/bash

set -e

# CRAN packages in cran.txt (the project's list: the packages wanted, never
# their dependencies). Their system dependencies, and those of their R
# dependencies, are looked up by pak (the r-hub system requirements
# database) and installed with apt; install2.r installs the packages and
# their R dependencies (bspm binaries on r2u, PPM binaries on rocker).
# Nothing to do without the list
if [ ! -f cran.txt ]; then
    exit 0
fi

function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

mapfile -t pkgs < <(grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' cran.txt)
if [ "${#pkgs[@]}" -eq 0 ]; then
    exit 0
fi

# system dependencies (skipped without apt)
install2.r --error --skipinstalled pak
if command -v apt-get > /dev/null 2>&1; then
    sys="$(Rscript -e "writeLines(as.character(unique(unlist(pak::pkg_sysreqs(commandArgs(TRUE))\$packages\$system_packages))))" "${pkgs[@]}")"
    if [ -n "${sys}" ]; then
        mapfile -t sys_pkgs <<< "${sys}"
        apt_install "${sys_pkgs[@]}"
    fi
fi

# the packages and their R dependencies
install2.r --error --skipinstalled -n -1 "${pkgs[@]}"

echo -e "\nInstall cran.txt, done!"
