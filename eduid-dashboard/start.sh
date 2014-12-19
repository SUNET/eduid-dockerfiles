#!/bin/sh

set -e

. /opt/eduid/bin/activate

chown eduid: /var/log/eduid /opt/eduid/run

chgrp eduid /opt/eduid/etc/eduid-dashboard.ini
chmod 640 /opt/eduid/etc/eduid-dashboard.ini

# Create metadata
cd /opt/eduid/etc && /opt/eduid/bin/make_metadata.py dashboard_pysaml2_settings.py | xmllint --format - > dashboard_metadata.xml

pserve_args=""
if [ -f /opt/eduid/src/setup.py ]; then
    pserve_args="--reload --monitor-restart"
fi

start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/pserve -- /opt/eduid/etc/eduid-dashboard.ini \
     --pid-file /opt/eduid/run/eduid-dashboard.pid \
     --log-file /var/log/eduid/eduid-dashboard.log \
    --user=eduid --group=eduid $pserve_args

echo $0: Exiting
