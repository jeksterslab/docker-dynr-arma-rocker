#!/bin/bash

set -e

# every package in cran.txt and github.txt loads; fails naming each one
# that does not
Rscript -e "
  Read <- function(file) {
    if (!file.exists(file)) {
      return(character(0))
    }
    x <- readLines(file, warn = FALSE)
    trimws(x[!grepl('^[[:space:]]*(#|$)', x)])
  }
  pkg <- unique(
    c(
      Read('cran.txt'),
      sub('@.*$', '', basename(Read('github.txt')))
    )
  )
  ok <- vapply(
    X = pkg,
    FUN = requireNamespace,
    FUN.VALUE = logical(1),
    quietly = TRUE
  )
  cat(sprintf('%d of %d packages load.\n', sum(ok), length(ok)))
  if (!all(ok)) {
    stop('Not installed or not loading: ', paste(pkg[!ok], collapse = ', '))
  }
"

echo -e "\nCheck packages, done!"
