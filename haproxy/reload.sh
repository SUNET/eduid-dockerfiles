#!/bin/sh

set -e

logger -i -t haproxy-reload "Checking config: $*"

/usr/sbin/haproxy -c $*

logger -i -t haproxy-reload "Config checked OK, reloading PID `cat /run/haproxy.pid`"

exec haproxy-systemd-wrapper $* -p /run/haproxy.pid -st /run/haproxy.pid
