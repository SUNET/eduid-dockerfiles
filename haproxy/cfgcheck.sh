#!/bin/sh

set -e

logger -i -t haproxy-cfgcheck "Checking config: $*"
exec /usr/sbin/haproxy -c $* | logger -i -t haproxy-cfgcheck
