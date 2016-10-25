#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'reg2vulcan'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/eduid'}
state_dir=${state_dir-"${base_dir}/run"}
metadata=${metadata-"${state_dir}/metadata.xml"}
ini=${ini-"${cfg_dir}/${eduid_name}.ini"}
pysaml2_settings=${pysaml2_settings-"${cfg_dir}/idp_pysaml2_settings.py"}
run=${run-'/opt/eduid/bin/reg2vulcan'}
extra_args=${extra_args-''}

chown -R eduid: "${log_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${ini}" || true
chmod 640 "${ini}" || true

# Look for executable in developers environment
if [ "x${PYTHONPATH}" != "x" ]; then
    found=0
    for src_dir in $(echo "${PYTHONPATH}" | tr ":" "\n"); do
	for this in "${src_dir}/reg2vulcan"; do
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

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

echo ""
echo "$0: Starting ${run} with config ${ini}"
exec start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/python -- "${run}" \
    ${extra_args}
