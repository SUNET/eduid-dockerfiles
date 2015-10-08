#!/bin/bash

set -e

# Not needed when not using pynavet, remove after deployment
#apt-get update
#apt-get -y install \
#    libxml2-dev \
#    libxslt-dev \
#    zlib1g-dev
#apt-get clean
#rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.nordu.net/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

#/opt/eduid/bin/pip install --pre -i ${PYPI} suds
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-msg

/opt/eduid/bin/pip freeze
