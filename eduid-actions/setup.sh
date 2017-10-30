#!/bin/bash

set -e

apt-get update
apt-get -y install \
    libffi-dev \
    libssl-dev

PYPI="https://pypi.sunet.se/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-actions
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid_action.tou
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid_action.mfa
/opt/eduid/bin/pip install       -i ${PYPI} raven
/opt/eduid/bin/pip install       -i ${PYPI} gunicorn==19.3.0

/opt/eduid/bin/pip freeze
