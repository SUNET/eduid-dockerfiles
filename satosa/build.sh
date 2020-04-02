#!/bin/bash

temp_image='satosa-docker:latest'
image='docker.sunet.se/eduid/satosa:latest'

set -ex

rm -rf satosa.build
git clone https://github.com/IdentityPython/SATOSA satosa.build
docker build --tag ${temp_image}  --no-cache=true satosa.build
docker tag ${temp_image} ${image}
docker push ${image}
