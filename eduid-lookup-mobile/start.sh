#!/bin/sh

set -e

# activate python virtualenv
. /opt/eduid/bin/activate

celery_args="--loglevel INFO"
if [ -f /opt/eduid/src/setup.py ]; then
    celery_args="--loglevel DEBUG --autoreload"
fi

cd /opt/eduid/src

celery worker --app=eduid_lookup_mobile --events --uid eduid --gid eduid $celery_args $*
