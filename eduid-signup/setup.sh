#!/bin/bash

set -e

apt-get update
apt-get -y dist-upgrade
apt-get -y install \
    git \
    libssl-dev \
    libffi-dev

apt-get clean
rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.nordu.net/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-signup
/opt/eduid/bin/pip install       -i ${PYPI} raven

/opt/eduid/bin/pip freeze
