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
run=${run-'/opt/eduid/bin/registrator'}
extra_args=${extra_args-''}

runas_user=${runas_user-'root'}
runas_group=${runas_group-'root'}

chown -R eduid: "${log_dir}"

# Look for executable in developers environment
#if [ "x${PYTHONPATH}" != "x" ]; then
#    found=0
#    for src_dir in $(echo "${PYTHONPATH}" | tr ":" "\n"); do
#	for this in "${src_dir}/registrator"; do
#	    if [ -x "${this}" ]; then
#		echo "$0: Found developer's entry point: ${this}"
#		run="${this}"
#		extra_args+=" --debug"
#		found=1
#		break
#	    fi
#	done
#	if [ $found -ne 0 ]; then
#	    # stop at first match
#	    break
#	fi
#    done
#fi

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

echo ""
echo "$0: Starting ${run}"
exec start-stop-daemon --start -c ${runas_user}:${runas_group} --exec \
     /opt/eduid/bin/python -- "${run}" \
    log \
    ${extra_args}
