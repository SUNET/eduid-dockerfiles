#!/bin/sh

set -e

celerybeat_file=${celerybeat_file-'/opt/eduid/etc/eduid_msg/celerybeat-schedule'}
logfile=${eduid_logfile-'/var/log/eduid/eduid-msg.log'}

. /opt/eduid/bin/activate

chgrp eduid /opt/eduid/etc/eduid_msg/eduid_msg.ini
chmod 640 /opt/eduid/etc/eduid_msg/eduid_msg.ini

celery_args="--loglevel INFO"
if [ -f /opt/eduid/src/setup.py ]; then
    celery_args="--loglevel DEBUG --autoreload"
else
    if [ -f /opt/eduid/etc/eduid_msg/eduid_msg_DEBUG ]; then
	# eduid-dev environment
	celery_args="--loglevel DEBUG"
    fi
fi

if [ ! -s "${celerybeat_file}" ]; then
    echo "$0: Creating celerybeat file ${celerybeat_file}"
    touch "${celerybeat_file}"
    chown eduid:eduid "${celerybeat_file}"
    chmod 640 "${celerybeat_file}"
fi

touch "${logfile}"
chgrp eduid "${logfile}"
chmod 660 "${logfile}"

cd /opt/eduid/etc/eduid_msg

exec celery worker --app=eduid_msg --events --uid eduid --gid eduid \
    --logfile="${logfile}" \
    $celery_args $*
