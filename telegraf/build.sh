#!/bin/bash

set -ex

# Remember to set TELEGRAF_VERSION and TELEGRAF_TAG för telegraf job in .jenkings.yaml if running on ci.sunet.se
_jenkins_job=${JENKINS_JOB}
_telegraf_version=${TELEGRAF_VERSION-$1}
_telegraf_tag=${TELEGRAF_TAG-$2}
_telegraf_image='local/telegraf'
_release_build=false

if [ -z "${_telegraf_version}" ]; then
	source TELEGRAF_VERSION
	_telegraf_image=$TELEGRAF_IMAGE
	_telegraf_version=$TELEGRAF_VERSION
	_telegraf_tag=${TELEGRAF_TAG-$TELEGRAF_VERSION}
	_release_build=true
fi

echo "TELEGRAF_IMAGE: ${_telegraf_image}"
echo "TELEGRAF_VERSION: ${_telegraf_version}"
echo "DOCKER TAG: ${_telegraf_tag}"
echo "RELEASE BUILD: ${_release_build}"

if [ ! -s telegraf_"${TELEGRAF_VERSION}"_amd64.deb ]; then
    test -x /usr/bin/curl || apt-get -y install curl
    curl https://dl.influxdata.com/telegraf/releases/telegraf_"${TELEGRAF_VERSION}"_amd64.deb > telegraf_"${TELEGRAF_VERSION}"_amd64.deb
fi

docker pull debian:testing
docker pull gcr.io/distroless/base
if [ -z "${_jenkins_job}" ]; then
  docker build --build-arg TELEGRAF_VERSION="${_telegraf_version}" --tag "${_telegraf_image}:latest"  --no-cache=true .
  docker tag "${_telegraf_image}:latest" "${_telegraf_image}:${_telegraf_tag}"
fi
