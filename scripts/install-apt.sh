#!/bin/bash

set -e

# system packages in apt.txt (the project's list), one call; nothing to do
# without the list
if [ ! -f apt.txt ]; then
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

mapfile -t pkgs < <(grep -v -e '^[[:space:]]*#' -e '^[[:space:]]*$' apt.txt)
if [ "${#pkgs[@]}" -gt 0 ]; then
    apt_install "${pkgs[@]}"
fi

echo -e "\nInstall apt.txt, done!"
