#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'pypiserver'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
packages_dir=${cfg_dir-"${base_dir}/packages"}
log_dir=${log_dir-"/var/log/${eduid_name}"}
extra_args=${extra_args-''}
run=${run-'/opt/eduid/bin/pypi-server'}

chown eduid: "${log_dir}"

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

echo ""
echo "$0: Starting ${run}"
${run} --fallback-url https://pypi.nordu.net/simple/ \
    --log-file "${log_dir}/pypiserver.log" \
    -v -v \
    $packages_dir

echo $0: Exiting
