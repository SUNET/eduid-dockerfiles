#!/bin/bash

set -e

apt-get update
apt-get -y install \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev
apt-get clean
rm -rf /var/lib/apt/lists/*

/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ suds
/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid-msg

/opt/eduid/bin/pip freeze
