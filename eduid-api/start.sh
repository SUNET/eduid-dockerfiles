#!/bin/sh

set -e

eduid_api_cfgfile=${eduid_api_cfgfile-'/opt/eduid/etc/eduid_api.ini'}
eduid_api_debug=${eduid_api_debug-'--debug'}

. /opt/eduid/bin/activate

chown eduid: /var/log/eduid

run=/opt/eduid/bin/eduid_api
if [ -x /opt/eduid/src/src/eduid_api/eduid_apibackend.py ]; then
    run=/opt/eduid/src/src/eduid_api/eduid_apibackend.py
fi

start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/python -- $run \
    --config-file $eduid_api_cfgfile \
    $eduid_api_debug

echo $0: Exiting
