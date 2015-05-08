#!/bin/bash

set -e
set -x

apt-get update
apt-get -y install \
    zlib1g-dev		# To get PIL zip compression
apt-get clean
rm -rf /var/lib/apt/lists/*

#PYPI="https://pypi.nordu.net/simple/"
PYPI="http://pypiserver.docker:8080/simple/"

#/opt/eduid/bin/pip install -i ${PYPI} raven
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-api
/opt/eduid/bin/pip install -i ${PYPI} jose
/opt/eduid/bin/pip install -i ${PYPI} vccs-client
/opt/eduid/bin/pip install -i ${PYPI} qrcode
/opt/eduid/bin/pip install -i ${PYPI} Pillow
/opt/eduid/bin/pip install -i ${PYPI} requests
/opt/eduid/bin/pip install --pre -i ${PYPI} pyhsm

/opt/eduid/bin/pip freeze
