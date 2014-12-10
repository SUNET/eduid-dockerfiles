#!/bin/bash

set -e

apt-get -y install \
    libxml2-dev \
    libxslt-dev \
    zlib1g-dev

/opt/eduid/bin/pip install -i https://pypi.nordu.net eduid-msg
