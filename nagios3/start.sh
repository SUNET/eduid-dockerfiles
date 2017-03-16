#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'nagios3'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/nagios3'}
state_dir=${state_dir-"${base_dir}/run"}
cache_dir=${cache_dir-'/var/cache/nagios3'}
checkresult_dir=${checkresult_dir-'/var/lib/nagios3/spool/checkresults'}
extra_args=${extra_args-''}

for dir_to_clean in "${cache_dir}" "${checkresult_dir}"; do
    test -d "${dir_to_clean}" && rm -rf "${dir_to_clean}"
    mkdir -p "${dir_to_clean}"
    chmod 770 "${dir_to_clean}"
done

for dir in "${log_dir}" "${state_dir}" "${cache_dir}" "${checkresult_dir}"; do
    test -d "${dir}" && chown -R nagios: "${dir}"
done

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

# for the pid file
mkdir -p /run/php

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
