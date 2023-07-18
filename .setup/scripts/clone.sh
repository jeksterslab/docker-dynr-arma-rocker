#!/bin/bash

git clone git@github.com:jeksterslab/docker-dynr-arma-rocker.git
rm -rf "$PWD.git"
mv docker-dynr-arma-rocker/.git "$PWD"
rm -rf docker-dynr-arma-rocker
