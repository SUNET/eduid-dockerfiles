#!/bin/bash

set -e
set -x

apt-get update
apt-get -y install \
    supervisor \
    fcgiwrap \
    libnet-ssleay-perl \
    libcgi-fast-perl \
    munin

apt-get clean
rm -rf /var/lib/apt/lists/*
