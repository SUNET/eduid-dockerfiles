#!/bin/sh

set -e

celerybeat_file=${celerybeat_file-'/opt/eduid/etc/eduid_msg/celerybeat-schedule'}

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-msg'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
ini=${ini-"${cfg_dir}/${eduid_name}.ini"}
log_dir=${log_dir-'/var/log/eduid'}
logfile=${logfile-"${log_dir}/${eduid_name}.log"}

chown eduid: "${log_dir}" "${state_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${ini}" || true
chmod 640 "${ini}" || true

celery_args="--loglevel INFO"
if [ -f /opt/eduid/src/setup.py ]; then
    celery_args="--loglevel DEBUG --autoreload"
else
    if [ -f "${cfg_dir}/eduid_msg_DEBUG" ]; then
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

cd "${cfg_dir}"

exec celery worker --app=eduid_msg --events --uid eduid --gid eduid \
    --logfile="${logfile}" \
    $celery_args
