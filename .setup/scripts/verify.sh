#!/usr/bin/env bash

# Clone or pull the private repository into .verify (local only; never
# uploaded), so that Verify() can compare it with this project.
#
# Git only: no R and no Apptainer. Usually called by
#   apptainer exec ~/work/sif/docs.sif make verify RECORD=TRUE
# Where SSH keys are not visible in the container (e.g., Roar), run it on the
# host first:
#   bash .setup/scripts/verify.sh

set -Eeuo pipefail

path="$(pwd)"
project="$(sed -n 's/^project <- "\(.*\)"$/\1/p' .setup/scripts/project.R | head -n 1)"
if [[ -z "${project}" ]]; then
  echo "Cannot find project in .setup/scripts/project.R" >&2
  exit 1
fi

private="${VERIFY_DIR:-${path}/.verify}"
if [[ -d "${private}/.git" ]]; then
  git -C "${private}" fetch -q origin
  git -C "${private}" reset -q --hard origin/HEAD
else
  git clone -q "git@github.com:jeksterslab-psu/${project}.git" "${private}"
fi

echo ".verify is at $(git -C "${private}" log --oneline -1)"