#!/bin/bash

set -e

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

## Strip binary installed libraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so

# Installation information
echo -e "Session information...\n"
R -q -e "sessionInfo()"

# Check dynr
echo -e "Check the dynr package...\n"
R -q -e "library(dynr)"
R -e "demo('LinearSDE', package = 'dynr')"
rm LinearSDE.*
rm Rplots.pdf
cat -e "/srv/build/CONTAINER_RELEASE_MSG"
echo -e "\nBuild done!"
