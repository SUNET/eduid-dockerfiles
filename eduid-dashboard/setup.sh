#!/bin/bash

set -e
set -x

apt-get -y install \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    xmlsec1 \
    libxml2-utils

/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid-dashboard
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ raven

/opt/eduid/bin/pip freeze
