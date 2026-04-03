#!/usr/bin/env bash
set -euo pipefail

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cmake libxml2-dev

R -q -e 'install.packages("renv", repos="https://cloud.r-project.org")'
R -q -e 'renv::restore(prompt = FALSE)'
