#!/bin/sh

set -e
set -x

redisuser=${redisuser-'redis'}
redisgroup=${redisgroup-'redis'}
logdir=${logdir-'/var/log/redis'}
redisdir=${redisdir-'/var/lib/redis'}
run=${run-'/usr/bin/redis-server'}
cfg_file=${cfg_file-'/etc/redis/redis.conf'}
extra_args=${extra_args-''}

test -d ${logdir} || (mkdir -p ${logdir}; chgrp ${redisgroup} ${logdir}; chmod 770 ${logdir})

test -d ${logdir} && chgrp ${redisgroup} ${logdir} && chmod 770 ${logdir}

echo ""
echo "$0: Starting ${run} ${cfg_file} with extra args: ${extra_args}"
exec start-stop-daemon --start \
    -c ${redisuser}:${redisgroup} \
    -d ${redisdir} \
    --exec ${run} ${cfg_file} ${extra_args}
