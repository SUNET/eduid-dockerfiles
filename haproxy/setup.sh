#!/bin/bash

set -e

apt-get update
apt-get -y dist-upgrade
apt-get -y install \
	curl \
	haproxy \
	inotify-tools \
	net-tools \
	netcat-openbsd \
	procps

# save space
rm -rf /var/lib/apt/lists/*
