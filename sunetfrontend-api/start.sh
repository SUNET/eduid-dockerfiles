#!/bin/sh

set -e
set -x

# These could be set from Puppet if multiple instances are deployed
sunetfrontend_name=${sunetfrontend_name-'sunetfrontend-api'}
app_name=${app_name-'api'}
base_dir=${base_dir-"/opt/eduid"}
project_dir=${project_dir-"${base_dir}/${sunetfrontend_name}"}
app_dir=${app_dir-"${project_dir}/${app_name}"}
# These *can* be set from Puppet, but are less expected to...
log_dir=${log_dir-'/var/log/dockers'}
state_dir=${state_dir-"${base_dir}/run"}
workers=${workers-1}
worker_class=${worker_class-sync}
worker_threads=${worker_threads-1}
worker_timeout=${worker_timeout-30}

chown -R eduid: "${log_dir}" "${state_dir}"
test -d /backends && chown -R eduid: /backends

# set PYTHONPATH if it is not already set using Docker environment
export PYTHONPATH=${PYTHONPATH-${project_dir}}

extra_args=""
if [ -d "/opt/eduid/src/sunet-frontend-api/sunetfrontend" ]; then
    # developer mode, restart on code changes
    extra_args="--reload"
fi

. ${base_dir}/bin/activate

# nice to have in docker run output, to check what
# version of something is actually running.
pip freeze

exec start-stop-daemon --start -c eduid:eduid --exec \
     ${base_dir}/bin/gunicorn \
     --pidfile "${state_dir}/${sunetfrontend_name}.pid" \
     -- \
     --bind 0.0.0.0:8080 \
     --workers ${workers} --worker-class ${worker_class} \
     --threads ${worker_threads} --timeout ${worker_timeout} \
     --access-logfile "${log_dir}/${sunetfrontend_name}-access.log" \
     --error-logfile "${log_dir}/${sunetfrontend_name}-error.log" \
     ${extra_args} sunetfrontend.run:app
