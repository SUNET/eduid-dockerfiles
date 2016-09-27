#!/bin/bash

set -e

apt-get update
apt-get -y install \
    libxslt1-dev \
    openssl \
    openjdk-8-jdk-headless
apt-get clean
rm -rf /var/lib/apt/lists/*
