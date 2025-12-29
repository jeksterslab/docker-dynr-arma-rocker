jeksterslab/dynr-arma-rocker
================
Ivan Jacob Agaloos Pesigan
2025-12-29

<!-- README.md is generated from .setup/readme/README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Make
Project](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/make.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/make.yml)
[![Docker and Apptainer Build and Push
\[amd64/arm64\]](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-apptainer-build-push-amd64-arm64.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-apptainer-build-push-amd64-arm64.yml)
[![Shell
Check](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/shellcheck.yml)
<!-- badges: end -->

## Description

Docker and Apptainer/Singularity containers for `R` projects based on
the [Rocker Project](https://rocker-project.org/) with the
[dynr](https://github.com/mhunter1/dynr) (arma branch) package.

## GitHub Actions

The `Docker and Apptainer Build and Push [amd64/arm64]` GitHub actions
workflow performs the following:

- Builds the Docker image specified by the `Dockerfile`.
- Pushes the image to
  [DockerHub](https://hub.docker.com/r/jeksterslab/dynr-arma-rocker)
  using the tags `latest` and
  `date and time of build (YEAR-MM-DD-HHMMSSMS)`.
- Builds the Singularity Image File (SIF) using Apptainer based on the
  Docker Hub image from the previous step.
- Creates a GitHub release named `dynr-arma-rocker-YEAR-MM-DD-HHMMSSMS`.
  Note that `dynr-arma-rocker-YEAR-MM-DD-HHMMSSMS.zip` contains the SIF.

## Docker Container

To launch `Rstudio Server`, run the following.

``` bash
docker run --rm -ti -e PASSWORD=yourpassword -p 127.0.0.1:8787:8787 jeksterslab/dynr-arma-rocker
```

Open `http://localhost:8787` on your web browser to launch
`Rstudio Server`.

- username: rstudio
- password: yourpassword

## Apptainer Shell

Download and unzip `dynr-arma-rocker-YEAR-MM-DD-HHMMSSMS.zip` from the
GitHub release to extract `dynr-arma-rocker-YEAR-MM-DD-HHMMSSMS.sif`.

``` bash
apptainer shell dynr-arma-rocker-YEAR-MM-DD-HHMMSSMS.sif
```
