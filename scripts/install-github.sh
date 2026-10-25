#!/bin/bash

set -e

# GitHub packages in github.txt (the project's list: owner/repo[@ref]),
# after the CRAN packages. Their system dependencies, and those of their R
# dependencies, are looked up by pak and installed with apt; their R
# dependencies (CRAN, from each DESCRIPTION) are installed with install2.r;
# then the packages, without dependencies. Nothing to do without the list
if [ ! -f github.txt ]; then
    exit 0
fi

# without a token the GitHub API allows 60 requests an hour, which these
# installs exceed: stop instead of failing halfway
if [ -z "$GITHUB_PAT" ]; then
    echo "GITHUB_PAT NOT set: cannot install github.txt" >&2
    exit 1
fi

function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

mapfile -t pkgs < <(grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' github.txt)
if [ "${#pkgs[@]}" -eq 0 ]; then
    exit 0
fi

# system dependencies (skipped without apt)
install2.r --error --skipinstalled pak remotes
if command -v apt-get > /dev/null 2>&1; then
    sys="$(Rscript -e "writeLines(as.character(unique(unlist(pak::pkg_sysreqs(commandArgs(TRUE))\$packages\$system_packages))))" "${pkgs[@]}")"
    if [ -n "${sys}" ]; then
        mapfile -t sys_pkgs <<< "${sys}"
        apt_install "${sys_pkgs[@]}"
    fi
fi

# their R dependencies with install2.r
deps="$(Rscript -e "d <- pak::pkg_deps(commandArgs(TRUE)); writeLines(d\$package[d\$type == 'standard'])" "${pkgs[@]}")"
if [ -n "${deps}" ]; then
    mapfile -t deps_pkgs <<< "${deps}"
    install2.r --error --skipinstalled -n -1 "${deps_pkgs[@]}"
fi

# the packages
Rscript -e "remotes::install_github(commandArgs(TRUE), dependencies = FALSE, upgrade = 'never')" "${pkgs[@]}"

echo -e "\nInstall github.txt, done!"
