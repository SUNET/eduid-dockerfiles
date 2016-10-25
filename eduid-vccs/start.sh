#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-vccs'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/eduid'}
ini=${ini-"${cfg_dir}/${eduid_name}.ini"}
run=${run-'/opt/eduid/bin/vccs_authbackend'}

chown -R eduid: "${log_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${ini}" || true
chmod 640 "${ini}" || true

if [ -x /opt/eduid/src/src/vccs_auth/vccs_authbackend.py ]; then
    run=/opt/eduid/src/src/vccs_auth/vccs_authbackend.py
fi
# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

echo ""
echo "$0: Starting ${run} with config ${ini}"
exec start-stop-daemon --start --quiet -c eduid:eduid \
     --pidfile "${state_dir}/${eduid_name}.pid" --make-pidfile \
     --exec /opt/eduid/bin/python -- $run \
     --config-file ${ini}
