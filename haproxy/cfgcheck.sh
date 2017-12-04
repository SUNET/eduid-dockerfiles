#!/bin/sh

set -e

logger -i -t haproxy-cfgcheck "Checking config: $*"
/usr/sbin/haproxy -c $* | logger -i -t haproxy-cfgcheck
