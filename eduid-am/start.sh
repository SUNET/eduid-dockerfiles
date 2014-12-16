#!/bin/sh

set -e

. /opt/eduid/bin/activate

chgrp eduid /opt/eduid/etc/eduid_am/eduid_am.ini
chmod 640 /opt/eduid/etc/eduid_am/eduid_am.ini

celery_args="--loglevel INFO"
if [ -f /opt/eduid/src/setup.py ]; then
    celery_args="--loglevel DEBUG --autoreload"
fi

cd /opt/eduid/etc/eduid_am

exec celery worker --app=eduid_am --events --uid eduid --gid eduid $celery_args $*
