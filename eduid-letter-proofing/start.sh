#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'letter-proofing'}
app_name=${app_name-'letter_proofing'}
base_dir=${base_dir-"/opt/eduid"}
project_dir=${project_dir-"${base_dir}/eduid-webapp/src"}
app_dir=${app_dir-"${project_dir}/${app_name}"}
# These *can* be set from Puppet, but are less expected to...
config_ns=/eduid/webapp/${app_name}
log_dir=${log_dir-'/var/log/eduid'}
state_dir=${state_dir-"${base_dir}/run"}
workers=${workers-1}
worker_class=${worker_class-sync}
worker_threads=${worker_threads-1}
worker_timeout=${worker_timeout-30}

chown eduid: "${log_dir}" "${state_dir}"

# set PYTHONPATH if it is not already set using Docker environment
export PYTHONPATH=${PYTHONPATH-${project_dir}}

extra_args=""
if [ -f "/opt/eduid/src/eduid-webapp/setup.py" ]; then
    # developer mode, restart on code changes
    extra_args="--reload"
fi

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

export EDUID_CONFIG_NS=${EDUID_CONFIG_NS-${config_ns}}

echo "Reading settings from: ${EDUID_CONFIG_NS-'No namespace set'}"
exec start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/gunicorn \
     --pidfile "${state_dir}/${eduid_name}.pid" \
     --user=eduid --group=eduid -- \
     --bind 0.0.0.0:8080 \
     --workers ${workers} --worker-class ${worker_class} \
     --threads ${worker_threads} --timeout ${worker_timeout} \
     --access-logfile "${log_dir}/${eduid_name}-access.log" \
     --error-logfile "${log_dir}/${eduid_name}-error.log" \
     ${extra_args} eduid_webapp.letter_proofing.run:app
