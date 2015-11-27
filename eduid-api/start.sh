#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-api'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/eduid'}
ini=${ini-"${cfg_dir}/${eduid_name}.ini"}
run=${run-'/opt/eduid/bin/eduid_api'}
extra_args=${extra_args-''}

chown eduid: "${log_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${ini}" || true
chmod 640 "${ini}" || true

# Look for executable in developers environment
if [ "x${PYTHONPATH}" != "x" ]; then
    found=0
    for src_dir in $(echo "${PYTHONPATH}" | tr ":" "\n"); do
	for this in "${src_dir}/eduid_apibackend.py" \
	    "${src_dir}/eduid_api/eduid_apibackend.py" \
	    "${src_dir}/eduid-api/eduid_apibackend.py"; do
	    if [ -x "${this}" ]; then
		echo "$0: Found developer's entry point: ${this}"
		run="${this}"
		extra_args+=" --debug"
		found=1
		break
	    fi
	done
	if [ $found -ne 0 ]; then
	    # stop at first match
	    break
	fi
    done
fi

if [ -f "${cfg_dir}/${eduid_name}_DEBUG" ]; then
    # eduid-dev environment
    extra_args+=" --debug"
fi

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

echo ""
echo "$0: Starting ${run} with config ${ini}"
exec start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/python -- "${run}" \
    --config-file "${ini}" \
    ${extra_args}
