#!/bin/bash

set -e

# Mplus demo: Linux x86_64 only (its installer cannot run on arm64)
if [ "$(uname -m)" != "x86_64" ]; then
    echo "Mplus demo: skipped on $(uname -m) (x86_64 only)"
    exit 0
fi

wget -q https://www.statmodel.com/download/install_mpluslinux_demo64.bin
sh install_mpluslinux_demo64.bin -i silent
rm -f install_mpluslinux_demo64.bin

# the installer can exit 0 without installing anything
if [ ! -x /opt/mplusdemo/mpdemo ]; then
    echo "Mplus demo: the installer did not create /opt/mplusdemo/mpdemo" >&2
    exit 1
fi
ln -sf /opt/mplusdemo/mpdemo /usr/local/bin/mpdemo
