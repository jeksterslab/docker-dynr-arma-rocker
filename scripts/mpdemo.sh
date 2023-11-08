#!/bin/bash

set -e

wget https://www.statmodel.com/download/install_mpluslinux_demo64.bin
sh install_mpluslinux_demo64.bin -i silent
ln -s /opt/mplusdemo/mpdemo /usr/local/bin/
rm -rf install_mpluslinux_demo64.bin
