#!/bin/sh

set -e

# check config
exec /usr/sbin/haproxy -c $*
