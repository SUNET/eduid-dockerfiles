#!/bin/sh

set -e

eduid_api_debug=${eduid_api_debug-'--debug'}

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-api'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/eduid'}
state_dir=${state_dir-"${base_dir}/run"}
ini=${ini-"${cfg_dir}/${eduid_name}.ini"}
run=${run-'/opt/eduid/bin/eduid_api'}

chown eduid: "${log_dir}" "${state_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${ini}" || true
chmod 640 "${ini}" || true

if [ -x /opt/eduid/src/src/eduid_api/eduid_apibackend.py ]; then
    # developer mode
    run=/opt/eduid/src/src/eduid_api/eduid_apibackend.py
fi

start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/python -- $run \
    --config-file $ini \
    $eduid_api_debug

echo $0: Exiting
