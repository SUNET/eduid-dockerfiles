#!/bin/bash

set -e
set -x

#  'xmlsec1',         # needed by make-metadata.py
#  'libxml2-dev',     # needed to install pyXMLSecurity
#  'libxslt1-dev',    # needed to install pyXMLSecurity
#  'build-essential', # needed to install PyKCS11
#  'zlib1g-dev',      # needed to install pyXMLSecurity

apt-get update
apt-get -y install \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    xmlsec1 \
    libxml2-utils
apt-get clean
rm -rf /var/lib/apt/lists/*

/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid-idp
/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid-idp-html
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ raven
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ pyXMLSecurity[PKCS11]
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ requests

/opt/eduid/bin/pip freeze
