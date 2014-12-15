#!/bin/sh

set -e

. /opt/eduid/bin/activate

chown eduid: /var/log/eduid /opt/eduid/run

chgrp eduid /opt/eduid/etc/eduid-signup.ini
chmod 640 /opt/eduid/etc/eduid-signup.ini

ls -l /opt/eduid/etc/eduid-signup.ini

pserve_args=""
if [ -f /opt/eduid/src/setup.py ]; then
    pserve_args="--reload"
fi

start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/pserve -- /opt/eduid/etc/eduid-signup.ini \
     --pid-file /opt/eduid/run/eduid-signup.pid \
     --log-file /var/log/eduid/eduid-signup.log \
    --user=eduid --group=eduid $pserve_args

echo $0: Exiting
