#!/bin/sh

set -e
set -x

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'munin'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/munin'}
state_dir=${state_dir-"${base_dir}/run"}
fastcgi_dir=${fastcgi_dir-"/var/run/munin/fastcgi/"}
extra_args=${extra_args-''}

mkdir -p "${fastcgi_dir}"

for dir in "${log_dir}" "${state_dir}" "${fastcgi_dir}"; do
    test -d "${dir}" && chown -R munin: "${dir}"
done

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
