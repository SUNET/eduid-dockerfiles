#!/bin/bash

set -e
set -x

#  libffi-dev         # needed by pysaml2
#  libssl-dev         # needed by pysaml2

apt-get update
apt-get -y install \
    git \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    xmlsec1 \
    libxml2-utils \
    libffi-dev \
    libssl-dev

apt-get clean
rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.nordu.net/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

. /opt/eduid/bin/activate

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-userdb
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-common[webapp]
# /opt/eduid/bin/pip install --pre -i ${PYPI} eduid-webapp
/opt/eduid/bin/pip install       -i ${PYPI} gunicorn

cd /opt/eduid && git clone https://github.com/SUNET/eduid-webapp.git eduid-authn
cd /opt/eduid/eduid-authn && python setup.py develop

/opt/eduid/bin/pip freeze
