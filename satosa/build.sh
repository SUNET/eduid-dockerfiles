#!/bin/bash

set -ex

rm -rf satosa.build
git clone https://github.com/IdentityPython/SATOSA satosa.build
docker build --tag "satosa-docker:latest"  --no-cache=true satosa.build
docker tag "satosa-docker:latest" "docker.sunet.se/eduid/satosa:latest"
