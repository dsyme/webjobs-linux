#!/bin/sh
set -e

# Following instructions from
# <https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container?tabs=debian&pivots=container-linux#enable-ssh>
service ssh start
# Add an empty string as the GHCS_NPM_TOKEN to prevent startup failures due to failing env var replacement in .npmrc
GHCS_NPM_TOKEN='' yarn run start
