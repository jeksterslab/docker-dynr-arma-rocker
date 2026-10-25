
<!-- README.md is generated from .setup/readme/README.Rmd, which rProject's
docker template writes. Edit .setup/readme/description.md, scripts/cran.txt,
scripts/github.txt, or .setup/scripts/project.R instead. -->

# jeksterslab/dynr-arma-rocker

<!-- badges: start -->

[![Docker Build and Push dynr-arma-rocker \[multi\]
(Daily)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-build-push-daily-multi-dynr-arma-rocker.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-build-push-daily-multi-dynr-arma-rocker.yml)
[![Docker Build and Push
\[multi\]](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-build-push-multi.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-build-push-multi.yml)
[![Make
Project](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/make.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/make.yml)
[![Non-ASCII
Check](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/non-ascii-check.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/non-ascii-check.yml)
[![Shell
Check](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/shellcheck.yml)
<!-- badges: end -->

## Description

An RStudio Server image based on the [Rocker
Project](https://rocker-project.org/) with
[dynr](https://github.com/mhunter1/dynr) built from source (the `arma`
branch), Stan, JAGS, ctsem, and the Mplus demo (amd64).

Based on `rocker/rstudio:latest`; built for linux/amd64 and linux/arm64.
Source: <https://github.com/jeksterslab/docker-dynr-arma-rocker>.

## Use

Docker (Docker Hub or the GitHub Container Registry):

``` bash
docker run -it jeksterslab/dynr-arma-rocker
docker run -it ghcr.io/jeksterslab/dynr-arma-rocker
```

Apptainer:

``` bash
apptainer pull dynr-arma-rocker.sif docker://jeksterslab/dynr-arma-rocker
apptainer shell dynr-arma-rocker.sif
```

## Contents

R packages from CRAN (`scripts/cran.txt`), with their dependencies:

- development: devtools, knitr, languageserver, lintr, remotes,
  rmarkdown, styler, testthat, tinytex
- Bayesian and continuous-time models: rjags, R2jags, rstan, ctsem

## Builds

- Docker Build and Push dynr-arma-rocker \[multi\] (Daily)
  (`docker-build-push-daily-multi-dynr-arma-rocker.yml`): daily at 00:00
  UTC, when the base image is rebuilt
- Docker Build and Push \[multi\] (`docker-build-push-multi.yml`): after
  Make Project
- Make Project (`make.yml`): on push
- Non-ASCII Check (`non-ascii-check.yml`): after Make Project
- Shell Check (`shellcheck.yml`): after Make Project

The images are pushed to Docker Hub and the GitHub Container Registry as
`jeksterslab/dynr-arma-rocker:latest`.
