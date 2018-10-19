#!/bin/sh

set -e
set -x

redisuser=${redisuser-'redis'}
redisgroup=${redisgroup-'redis'}
logdir=${logdir-'/var/log/redis'}
datadir=${datadir-'/data'}
run=${run-'/usr/bin/redis-server'}
cfg_file=${cfg_file-'/etc/redis/redis.conf'}
sentinel_cfg_file=${sentinel_cfg_file-"${datadir}/sentinel.conf"}
extra_args=${extra_args-''}

test -d ${logdir} || (mkdir -p ${logdir}; chgrp ${redisgroup} ${logdir}; chmod 770 ${logdir})

for dir in ${logdir} ${datadir}; do
    test -d ${dir} && chgrp -R ${redisgroup} ${dir} && chmod 770 ${dir}
done
test -f /etc/redis/redis.conf && chgrp ${redisgroup} /etc/redis/redis.conf

test -f /usr/bin/redis-sentinel || ln -s /usr/bin/redis-server /usr/bin/redis-sentinel

if echo $extra_args | grep -qe "--sentinel"; then
    # redis wants to write state to the config file in sentinel mode :(
    banner SENTINEL
    echo
    if [ -f $sentinel_cfg_file ]; then
	echo "$0: IGNORING ${cfg_file} in favor of existing ${sentinel_cfg_file}"
    else
	echo "$0: Initializing ${sentinel_cfg_file} from ${cfg_file}"
	grep -e ^bind -e ^port -e ^sentinel "${cfg_file}" > "${sentinel_cfg_file}"
	chown "${redisuser}:${redosgroup}" "${sentinel_cfg_file}"
	chmod 600 "${sentinel_cfg_file}"
    fi
    cfg_file=$sentinel_cfg_file
fi


echo ""
echo "$0: Starting ${run} ${cfg_file} with extra args: ${extra_args}"
exec start-stop-daemon --start \
    -c ${redisuser}:${redisgroup} \
    -d ${datadir} \
    --exec ${run} -- ${cfg_file} ${extra_args}
