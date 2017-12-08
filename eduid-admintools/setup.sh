#!/bin/bash

set -e

PYPI="https://pypi.sunet.se/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

/opt/eduid/bin/pip install --pre -i ${PYPI} 'eduid-userdb'
/opt/eduid/bin/pip install --pre -i ${PYPI} 'proquint==0.1.0'
/opt/eduid/bin/pip install --pre -i ${PYPI} 'python-etcd==0.4.5'
/opt/eduid/bin/pip install --pre -i ${PYPI} 'PyYAML==3.12'

# Need to upgrade TLSv1 to TLSv1_2 to be able to connect to our etcd v3 nodes
#sed -i -e 's/ssl.PROTOCOL_TLSv1$/ssl.PROTOCOL_TLSv1_2/' /opt/eduid/local/lib/python2.7/site-packages/etcd/client.py

/opt/eduid/bin/pip freeze
