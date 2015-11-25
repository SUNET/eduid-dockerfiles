#!/bin/bash

set -e
set -x

apt-get update
apt-get -y install \
    unbound

apt-get clean
rm -rf /var/lib/apt/lists/*
