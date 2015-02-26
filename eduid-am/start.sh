#!/bin/sh

set -e

. /opt/eduid/bin/activate

# don't fail on these, in case the cfg-dir is mounted read only
chgrp eduid /opt/eduid/etc/eduid_am/eduid_am.ini || true
chmod 640 /opt/eduid/etc/eduid_am/eduid_am.ini || true

celery_args="--loglevel INFO"
if [ -f /opt/eduid/src/setup.py ]; then
    celery_args="--loglevel DEBUG --autoreload"
fi

cd /opt/eduid/etc/eduid_am

exec celery worker --app=eduid_am --events --uid eduid --gid eduid $celery_args $*
