#!/bin/bash

set -e

apt-get update
apt-get -y install \
	curl \
	libnettle6 \
	yhsm-tools
apt-get clean
rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.sunet.se/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

/opt/eduid/bin/pip install --pre -i ${PYPI} vccs-auth
/opt/eduid/bin/pip install       -i ${PYPI} raven

/opt/eduid/bin/pip freeze
