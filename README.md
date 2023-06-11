# jeksterslab/dynr-arma-rocker

Ivan Jacob Agaloos Pesigan

<!-- badges: start -->
[![Docker and Apptainer Build and Push](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-apptainer-build-push.yml/badge.svg)](https://github.com/jeksterslab/docker-dynr-arma-rocker/actions/workflows/docker-apptainer-build-push.yml)
<!-- badges: end -->

## Description

A Docker container for `R` projects based on the [Rocker Project](https://rocker-project.org/)
with the [dynr](https://github.com/mhunter1/dynr) (arma branch) package.

## Run

To launch `Rstudio Server`, run the following.

```bash
docker run --rm -ti -e PASSWORD=yourpassword -p 8787:8787 jeksterslab/dynr-arma-rocker
```

Open `http://localhost:8787` on your web browser to launch `Rstudio Server`.

- username: rstudio
- password: yourpassword
