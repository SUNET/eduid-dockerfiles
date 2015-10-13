#!/bin/bash

set -e

PYPI="https://pypi.nordu.net/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

/opt/eduid/bin/pip install --pre -i ${PYPI} 'eduid-am'
# eduid-api currently doesn't do attribute updating
#/opt/eduid/bin/pip install -i https://pypi.nordu.net/simple/ eduid-api-amp
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-signup-amp
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-dashboard-amp
# /opt/eduid/bin/pip install --pre -i ${PYPI} eduid_action.tou
# XXX the four packages below are dependencies for eduid_action.tou.
# Once eduid_action.tou is in pypi.nordu.net, the line above can be
# uncommented and the ones below deleted.
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-userdb
/opt/eduid/bin/pip install --pre -i ${PYPI} eduid-actions
/opt/eduid/bin/pip install 'Babel==1.3'
/opt/eduid/bin/pip install 'lingua==1.5'

/opt/eduid/bin/pip freeze
