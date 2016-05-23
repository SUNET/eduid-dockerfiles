#!/bin/bash
#

set -e
set -x

apt-get update
apt-get -y dist-upgrade
apt-get -y install \
       libxml2-dev \
       libxslt1-dev \
       xmlsec1 \
       libxml2-utils

apt-get clean
rm -rf /var/lib/apt/lists/*
