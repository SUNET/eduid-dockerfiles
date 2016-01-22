#!/bin/sh

set -e
set -x

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'unbound'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"/etc/unbound"}
extra_args=${extra_args-''}
verbose=${verbose-'-v'}
unbound_interface=${unbound_interface-'127.0.0.1'}

sed -ie "s/UNBOUND_INTERFACE/${unbound_interface}/g" "${cfg_dir}/unbound.conf"

echo "$0: Unbound config"
cat "${cfg_dir}/unbound.conf"
echo ---

test -d /etc/unbound/unbound.conf.d/ || mkdir -p /etc/unbound/unbound.conf.d/

exec /usr/sbin/unbound $verbose -dc "${cfg_dir}/unbound.conf"
