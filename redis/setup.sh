#!/bin/bash

set -e
set -x

apt-get update
apt-get -y install \
    redis-server \
    sysvbanner \
    python-virtualenv
apt-get clean
rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.sunet.se/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

virtualenv -p python3 /opt/eduid/
# redis-trib are cluster management scripts
# 0.5.2 has an installation issue, unpin when it is resolved
# https://github.com/projecteru/redis-trib.py/issues/11
/opt/eduid/bin/pip install       -i ${PYPI} "redis-trib==0.5.1"
# for testing
/opt/eduid/bin/pip install       -i ${PYPI} redis
/opt/eduid/bin/pip install       -i ${PYPI} redis-py-cluster

/opt/eduid/bin/pip freeze
