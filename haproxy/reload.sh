#!/bin/sh

set -e

logger -i -t haproxy-reload "Checking config: $*"

/usr/sbin/haproxy -c $*

logger -i -t haproxy-reload "Config checked OK, reloading haproxy-systemd-wrapper"

# There is good discussion about how to restart haproxy without loosing requests at
#
#   https://www.haproxy.com/blog/truly-seamless-reloads-with-haproxy-no-more-hacks/
#
# However, running in a Docker container imposes some limitations, as does running
# haproxy < 1.8
#

# NOTE: This variant doesn't work because Docker sees the original PID terminating
#exec haproxy-systemd-wrapper $* -p /run/haproxy.pid -sf `cat /run/haproxy.pid`

# PID 1 is the haproxy-systemd-wrapper, it will re-exec itself on SIGUSR2
kill -USR2 1
