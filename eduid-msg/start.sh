#!/bin/sh

set -e

. /opt/eduid/bin/activate

chgrp eduid /opt/eduid/etc/eduid_msg/eduid_msg.ini
chmod 640 /opt/eduid/etc/eduid_msg/eduid_msg.ini

celery_args="--loglevel INFO"
if [ -f /opt/eduid/src/setup.py ]; then
    celery_args="--loglevel DEBUG --autoreload"
fi

cd /opt/eduid/etc/eduid_msg

exec celery worker --app=eduid_msg --events --uid eduid --gid eduid $celery_args $*
