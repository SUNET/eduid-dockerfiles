#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'icinga'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
log_dir=${log_dir-'/var/log/icinga'}
state_dir=${state_dir-"${base_dir}/run"}
cache_dir=${cache_dir-'/var/cache/icinga'}
lib_dir=${lib_dir-'/var/lib/icinga'}
checkresult_dir=${checkresult_dir-'/var/lib/icinga/spool/checkresults'}
extra_args=${extra_args-''}

for dir_to_clean in "${cache_dir}" "${checkresult_dir}"; do
    test -d "${dir_to_clean}" && rm -rf "${dir_to_clean}"
    mkdir -p "${dir_to_clean}"
    chmod 770 "${dir_to_clean}"
done

for dir in "${log_dir}" "${state_dir}" "${cache_dir}" "${checkresult_dir}" "${lib_dir}"; do
    test -d "${dir}" && chown -R nagios: "${dir}"
done

# nice to have in docker run output, to check what
# version of something is actually running.
/opt/eduid/bin/pip freeze

# for the pid file
mkdir -p /run/php

# Export static content to nginx container, if data volume mount is present
test -d /icinga_data && rsync --delete -va /usr/share/icinga/htdocs/ /icinga_data/htdocs
test -L /icinga_data/htdocs/jquery && rm /icinga_data/htdocs/jquery
test -L /icinga_data/htdocs/jquery-ui && rm /icinga_data/htdocs/jquery-ui
test -d /icinga_data && rsync --delete -va /usr/share/javascript/jquery/ /icinga_data/htdocs/jquery
test -d /icinga_data && rsync --delete -va /usr/share/javascript/jquery-ui/ /icinga_data/htdocs/jquery-ui
#test -d /icinga_data && rsync --delete -va /etc/icinga/ /icinga_data/conf   # hope there are no secrets in there
test -d /icinga_data && (cd /icinga_data/ && tar zxvf /stylesheets.tar.gz)   # aaaaaaaaaaaaaaaargh

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
