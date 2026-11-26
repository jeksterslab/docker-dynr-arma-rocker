#!/usr/bin/env bash
# Build JAGS 5 from source into /usr/local, for CRAN's rjags (5-x needs
# JAGS 5.x.y; Ubuntu's apt has JAGS 4). Use this until apt has JAGS 5.
# Runs as root in the image build, before install-cran.sh installs rjags.
# Usage: bash rjags_sys.sh

set -Eeuo pipefail

jags_version="5.0.2"
jags_sha256="80143e23fc6feca01d4cce440fd8f6aa865a03333ed36baf9e0ce30a8f9e3aea"
jags_url="https://downloads.sourceforge.net/project/mcmc-jags/JAGS/5.x/Source/JAGS-${jags_version}.tar.gz"

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

# jags build dependencies (C, C++, Fortran, BLAS, LAPACK)
apt_install         \
    ca-certificates \
    curl            \
    make            \
    gcc             \
    g++             \
    gfortran        \
    libblas-dev     \
    liblapack-dev   \
    pkg-config

# apt's JAGS 4 must not shadow JAGS 5
if dpkg -s jags >/dev/null 2>&1; then
    apt-get remove -y jags
fi

build_dir="$(mktemp -d)"
if [ -z "${build_dir}" ] || [ ! -d "${build_dir}" ]; then
    echo "rjags_sys.sh: no build folder" >&2
    exit 1
fi
trap 'rm -rf "${build_dir}"' EXIT

# download and verify
curl -fsSL --retry 3 -o "${build_dir}/jags.tar.gz" "${jags_url}"
echo "${jags_sha256}  ${build_dir}/jags.tar.gz" | sha256sum -c -

# configure, build, install
tar -xzf "${build_dir}/jags.tar.gz" -C "${build_dir}"
cd "${build_dir}/JAGS-${jags_version}"
./configure --prefix=/usr/local
make -j"$(nproc)"
make install
ldconfig
cd /

# check
modversion="$(pkg-config --modversion jags)"
echo "JAGS ${modversion}"
case "${modversion}" in
    5.*) ;;
    *)
        echo "rjags_sys.sh: pkg-config finds JAGS ${modversion}, not 5.x" >&2
        exit 1
        ;;
esac

echo -e "\nInstall JAGS ${jags_version}, done!"
