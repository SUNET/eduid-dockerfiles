#!/bin/sh

set -e

# check config
exec /usr/sbin/haproxy -c $*

if [ ! -f /run/haproxy.pid ]; then
    echo "$0: Pid-file /run/haproxy.pid does not exist, can't send USR2 signal"
    exit 1
fi

kill -USR2 $(cat /run/haproxy.pid)

echo "haproxy gracefully restarted"
