#!/bin/bash

set -e
set -x

apt-get -y install \
    zlib1g-dev		# To get PIL zip compression

#/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ raven
/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid-api
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ jose
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ vccs-client
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ qrcode
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ Pillow
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ requests
/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ pyhsm

/opt/eduid/bin/pip freeze
