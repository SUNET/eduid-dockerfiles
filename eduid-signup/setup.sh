#!/bin/bash

set -e

#apt-get -y install \

/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ eduid-signup
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ raven

/opt/eduid/bin/pip freeze
