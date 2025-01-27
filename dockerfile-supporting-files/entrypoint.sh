#!/bin/sh
set -e

# Following instructions from
# <https://learn.microsoft.com/en-us/azure/app-service/configure-custom-container?tabs=debian&pivots=container-linux#enable-ssh>
service ssh start
dotnet WebApi.dll
