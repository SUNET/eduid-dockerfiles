#!/bin/bash

set -e

# Set exec bit on build script
chmod 755 /opt/eduid/build.sh

export VIRTUAL_ENV="/opt/eduid/"
export PIP_DOWNLOAD_CACHE=/var/cache/jenkins/pip
export PIP_INDEX_URL=https://pypi.nordu.net/simple/

. $VIRTUAL_ENV/bin/activate

# Pre-install common or slow Python packages
pip install -U setuptools
pip install nose nosexcover pylint mock==1.0.1
pip install pysaml2==4.0.3rc1 "pymongo>=2.8,<3" redis>=2.10.5 PyNaCl>=1.0.1

