#!/bin/sh

set -e

logger -i -t haproxy-reload "Checking config: $*"

/usr/sbin/haproxy -c $*

logger -i -t haproxy-reload "Config checked OK, reloading"

exec haproxy-systemd-wrapper -p <%= @haproxy_pidfile %> -st $(cat <%= @haproxy_pidfile %>)
