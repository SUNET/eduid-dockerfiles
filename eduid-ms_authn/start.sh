#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name="${eduid_name-eduid-authn}"
base_dir="${base_dir-/opt/eduid}"
cfg_dir="${cfg_dir-${base_dir}/etc}"
log_dir="${log_dir-/var/log/eduid}"
state_dir="${state_dir-${base_dir}/run}"
ini="${ini-${cfg_dir}/${eduid_name}.ini}"
saml2_settings="${saml2_settings-${cfg_dir}/saml2_settings.py}"
run="${state_dir}/${eduid_name}.pid"

chown eduid: "${log_dir}" "${state_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${ini}" || true
chmod 640 "${ini}" || true

extra_args=""
if [ -f "/opt/eduid/src/eduid-webapp/setup.py" ]; then
    # developer mode, restart on code changes
    extra_args="--reload"
fi

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

echo ""
echo "$0: Starting ${run} with config ${ini}"
gunicorn --pid ${run} \
        --env EDUID_CONFIG=${ini} \
        --env SAML2_SETTINGS_MODULE=${saml2_settings} \
        --access-logfile ${log_dir}/access.log \
        --error-logfile ${log_dir}/error.log \
        --bind 0.0.0.0:8080 \
        ${extra_args} \
        eduid_webapp.authn.run:app
