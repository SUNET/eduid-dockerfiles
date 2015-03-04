#!/bin/bash

set -e

apt-get update
apt-get -y install \
    libnettle4 \
    yhsm-tools
apt-get clean
rm -rf /var/lib/apt/lists/*

/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ vccs-auth
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ raven

/opt/eduid/bin/pip freeze
