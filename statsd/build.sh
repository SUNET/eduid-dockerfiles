#!/bin/bash

_statsd_version=$1
_statsd_tag=$2
_statsd_image='local/statsd'

if [ -z "${_statsd_version}" ]; then
	source STATSD_VERSION
	_statsd_image=$STATSD_IMAGE
	_statsd_version=$STATSD_VERSION
	_statsd_tag=${STATSD_TAG-$STATSD_VERSION}
	_release_build=true
fi

echo "STATSD_IMAGE: ${_statsd_image}"
echo "STATSD_VERSION: ${_statsd_version}"
echo "DOCKER TAG: ${_statsd_tag}"

test -d statsd || git clone -b $_statsd_version https://github.com/etsy/statsd/ statsd

docker build --build-arg STATSD_VERSION=${_statsd_version} --tag "${_statsd_image}:${_statsd_tag}"  --no-cache=true .
