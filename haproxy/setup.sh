#!/bin/bash

set -e

# To replace the dependency on a wget:ed a tar.gz over http as seen in the
# official haproxy image we get the equivalent version from Debian, which
# Unfortunately is only available from backports.
echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

apt-get update
apt-get -y dist-upgrade
apt-get -t jessie-backports -y install \
    haproxy

# save space
rm -rf /var/lib/apt/lists/*
