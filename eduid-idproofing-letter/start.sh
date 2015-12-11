#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-idproofing-letter'}
app_name=${app_name-'idproofing_letter'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/eduid'}
state_dir=${state_dir-"${base_dir}/run"}
gunicorn_args="--bind 0.0.0.0:8080 ${app_name}:app"

chown eduid: "${log_dir}"

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

echo "Reading settings from: ${IDPROOFING_LETTER_SETTINGS-'No settings file'}"
exec start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/gunicorn \
     --pidfile "${state_dir}/${eduid-name}.pid" \
     --user=eduid --group=eduid -- $gunicorn_args
