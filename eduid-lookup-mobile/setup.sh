#!/bin/bash

set -e

# APT dependencys for eduid_msg
apt-get update
apt-get -y install \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev
apt-get clean
rm -rf /var/lib/apt/lists/*

/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid_lookup_mobile
# until eduid_msg is a setup.py dependency of eduid_lookup_mobile
/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid_msg

/opt/eduid/bin/pip freeze
