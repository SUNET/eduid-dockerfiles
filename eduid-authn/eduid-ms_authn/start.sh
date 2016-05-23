#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name="${eduid_name-eduid-authn}"
base_dir="${base_dir-/opt/eduid}"
project_dir="${project_dir-${base_dir}/eduid-webapp/src}"
cfg_dir="${cfg_dir-${base_dir}/etc}"
log_dir="${log_dir-${base_dir}/log}"
state_dir="${state_dir-${base_dir}/run}"
# config="${ini-${cfg_dir}/${eduid_name}.ini}"
saml2_settings="${saml2_settings-${cfg_dir}/saml2_settings.py}"
run="${state_dir}/${eduid_name}.pid"
workers="${workers-1}"
worker_class="${worker_class-sync}"
worker_threads="${worker_threads-1}"
worker_timeout="${worker_timeout-30}"

chown eduid: "${log_dir}" "${state_dir}"

# || true to not fail on read-only cfg_dir
# chgrp eduid "${ini}" || true
# chmod 640 "${ini}" || true

# set PYTHONPATH if it is not already set using Docker environment
export PYTHONPATH=${PYTHONPATH-${project_dir}}

echo "PYTHONPATH=${PYTHONPATH}"

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

extra_args=""
if [ -f "/opt/eduid/src/eduid-webapp/setup.py" ]; then
    # developer mode, restart on code changes
    extra_args="--reload"
fi

echo ""
echo "$0: Starting ${run}"

exec start-stop-daemon --start -c eduid:eduid --exec \
    /opt/eduid/bin/gunicorn \
    --pidfile ${run} --user eduid --group eduid -- \
    --workers ${workers} --worker-class ${worker_class} \
    --threads ${worker_threads} --timeout ${worker_timeout} \
    --env SAML2_SETTINGS_MODULE=${saml2_settings} \
    --access-logfile "${log_dir}/${eduid_name}-access.log" \
    --error-logfile "${log_dir}/${eduid_name}-error.log" \
    --bind 0.0.0.0:8080 \
    ${extra_args} eduid_webapp.authn.run:app