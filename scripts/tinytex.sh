#!/bin/bash

set -e

# tinytex
install2.r --error --skipinstalled -n -1 \
    tinytex

# try() to avoid errors on arm64
# https://github.com/rstudio/tinytex-releases/issues/37

# uninstall tinytex
R -e "                                       \
  try(                                       \
    tinytex::uninstall_tinytex(force = TRUE) \
  )                                          \
"

# install tinytex package
R -e "                        \
  try(                        \
    tinytex::install_tinytex( \
      bundle = 'TinyTeX',     \
      force = TRUE,           \
      dir =  '/opt/TinyTeX'   \
    )                         \
  )                           \
"

# Check tinytex
echo -e "Check tinytex...\n"
R -e "tinytex::is_tinytex()"
echo -e "\nInstall tinytex, done!"
