#! /bin/bash
#SBATCH --job-name=make
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=06:00:00
#SBATCH --output=make.out
#SBATCH --error=make.err

###############################################################################
# Written once by rProject::Template() (inst/template/once/sim-make.sh);
# Conform() flags a copy that differs.
#
# Every project type (package, talk, lib, docker) has one.
#
# Usage (on the submit node, from .sim/):
#   sbatch -A open -J <project> make.sh    # build and publish the project
#   PUSH=0 sbatch make.sh                  # make all only; nothing is pushed
#   FRESH=1 sbatch make.sh                 # publish a fresh private clone
#   CLEAN=1 sbatch make.sh                 # remove generated files first
#   PROJECT=/path/to/clone sbatch make.sh  # build another copy
#
# Description:
#   make project, then make release (make all, the secret scan, make auto),
#   which stops at the first failure; PUSH=0 runs make all instead. make all
#   is serial, so one CPU and one BLAS thread keep the CPU busy; more CPUs
#   would sit idle. After a run, check with seff <jobid>, and set --mem to
#   the peak plus 10%.
#
# Settings (environment variables):
#   PROJECT      the project folder (default: the folder above .sim/)
#   SIF          the image (default: ~/work/sif/docs.sif)
#   PUSH=0       make all only: no secret scan, no make auto (default: 1)
#   FRESH=1      clone the private repository (.setup/repo/private-github.md
#                of PROJECT) into ${FRESH_DIR}/fresh-<repo>-<job>/ and build
#                that clone, so make auto publishes the pushed state, not the
#                working copy (default: 0)
#   FRESH_DIR    where the fresh clone goes (default: tmp/ next to the
#                project, as for the other host scripts)
#   CLEAN=1      remove the generated vignette files and ${CLEAN_FILES}
#   CLEAN_FILES  more files to remove, relative to PROJECT
###############################################################################

set -Eeuo pipefail

PROJECT=${PROJECT:-${SLURM_SUBMIT_DIR:-${PWD}}/..}
PROJECT=$(readlink -f "${PROJECT}")
SIF=${SIF:-${HOME}/work/sif/docs.sif}
# ~/work is a symlink on some machines: bind its target, so that git in the
# container finds the SSH keys (make auto clones and pushes)
WORK=$(readlink -f "${HOME}/work")
BINDS=(-B "${HOME}/work:${WORK}")
if [ -d /scratch/ibp5092 ]; then
  BINDS+=(-B /scratch/ibp5092)
fi

# one thread per library, one make job
export OMP_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 MKL_NUM_THREADS=1
export OPENBLAS_CORETYPE=${OPENBLAS_CORETYPE:-Haswell}
export MAKEFLAGS=-j1

if [ "${FRESH:-0}" = "1" ]; then
  REPO_FILE="${PROJECT}/.setup/repo/private-github.md"
  if [ ! -f "${REPO_FILE}" ]; then
    echo "FRESH=1: no ${REPO_FILE}" >&2
    exit 1
  fi
  REPO=$(head -n 1 "${REPO_FILE}" | tr -d '[:space:]')
  if [[ ! "${REPO}" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
    echo "FRESH=1: not an OWNER/REPO: ${REPO}" >&2
    exit 1
  fi
  OWNER=${REPO%%/*}
  # the SSH host: github-<owner> when ~/.ssh/config defines that alias
  HOST=github.com
  ALIAS="^Host[[:space:]]+(.*[[:space:]])?github-${OWNER}([[:space:]]|$)"
  if grep -Eqs "${ALIAS}" "${HOME}/.ssh/config"; then
    HOST=github-${OWNER}
  fi
  FRESH_DIR=${FRESH_DIR:-$(dirname "${PROJECT}")/tmp}
  CLONE="${FRESH_DIR}/fresh-${REPO##*/}-${SLURM_JOB_ID:-$$}/${REPO##*/}"
  mkdir -p "$(dirname "${CLONE}")"
  git clone "git@${HOST}:${REPO}.git" "${CLONE}"
  # .setup/repo/ is private: the clone has it only when Overleaf does
  if [ ! -d "${CLONE}/.setup/repo" ]; then
    cp -R "${PROJECT}/.setup/repo" "${CLONE}/.setup/repo"
  fi
  PROJECT=${CLONE}
fi

if [ ! -f "${PROJECT}/Makefile" ]; then
  echo "No Makefile in ${PROJECT}" >&2
  exit 1
fi

cd "${PROJECT}"
COMMIT=$(git log -1 --format='%h %s' 2>/dev/null || true)
echo "Processing: ${PROJECT} (${COMMIT})"

if [ "${CLEAN:-}" = "1" ]; then
  echo "Removing generated files..."
  # CLEAN_FILES is a list: split on spaces on purpose
  # shellcheck disable=SC2086
  rm -f vignettes/session.Rmd vignettes/vignettes.bib ${CLEAN_FILES:-}
fi

apptainer exec "${BINDS[@]}" "${SIF}" make project
if [ "${PUSH:-1}" = "0" ]; then
  apptainer exec "${BINDS[@]}" "${SIF}" make all
else
  apptainer exec "${BINDS[@]}" "${SIF}" make release
fi

echo "done"
