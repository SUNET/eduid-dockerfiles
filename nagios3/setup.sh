#!/bin/bash

set -e
set -x

apt-get update
apt-get -y install \
    fcgiwrap \
    php-fpm \
    supervisor \
    nagios3 \
    libjson-perl \
    liburi-perl \
    libnagios-plugin-perl \
    nagios-nrpe-plugin \
    nagios-plugins-contrib \
    nsca-client \
    sendemail

apt-get clean
rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.nordu.net/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

/opt/eduid/bin/pip install -i ${PYPI} jose
/opt/eduid/bin/pip install -i ${PYPI} requests

/opt/eduid/bin/pip freeze
