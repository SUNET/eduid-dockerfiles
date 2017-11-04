#!/bin/bash

set -e
set -x


PYPI="https://pypi.sunet.se/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

#/opt/eduid/bin/pip install -i ${PYPI} raven
#/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-api
#/opt/eduid/bin/pip install -i ${PYPI} jose
#/opt/eduid/bin/pip install -i ${PYPI} requests

/opt/eduid/bin/pip freeze
