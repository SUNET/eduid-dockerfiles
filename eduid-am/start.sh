#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-am'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
ini=${ini-"${cfg_dir}/${eduid_name}.ini"}
log_dir=${log_dir-'/var/log/eduid'}
logfile=${logfile-"${log_dir}/${eduid_name}.log"}
state_dir=${state_dir-"${base_dir}/run"}
celerybeat_file=${celerybeat_file-"${state_dir/celerybeat-schedule"}

chown eduid: "${log_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${ini}" || true
chmod 640 "${ini}" || true

celery_args="--loglevel INFO"
if [ -f /opt/eduid/src/setup.py ]; then
    # eduid-dev environment
    celery_args="--loglevel DEBUG --autoreload"
fi

touch "${logfile}"
chgrp eduid "${logfile}"
chmod 660 "${logfile}"

cd "${cfg_dir}"

exec celery worker --app=eduid_am --events --uid eduid --gid eduid \
    --logfile="${logfile}" \
    -s "${celerybeat_file}" \
    $celery_args
