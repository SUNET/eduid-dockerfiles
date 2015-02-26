#!/bin/bash

set -e

/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid-am
# eduid-api currently doesn't do attribute updating
#/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ eduid-api-amp
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ eduid-signup-amp
/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ eduid-dashboard-amp

/opt/eduid/bin/pip freeze
