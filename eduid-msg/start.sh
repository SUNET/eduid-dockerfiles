#!/bin/sh

set -e

. /opt/eduid/bin/activate

cd /opt/eduid/etc/eduid_msg
exec celery worker --app=eduid_msg -E --loglevel INFO -u eduid $*
