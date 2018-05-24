#!/bin/bash

set -e
set -x

export DEBIAN_FRONTEND noninteractive

/bin/sed -i s/deb.debian.org/ftp.se.debian.org/g /etc/apt/sources.list

apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y \
      git \
      build-essential \
      libpython-dev \
      libssl-dev \
      libxml2-dev \
      libxslt1-dev \
      xmlsec1 \
      libxml2-utils \
      python-virtualenv \
      iputils-ping \
      procps \
      bind9-host \
      netcat-openbsd \
      curl \
    && apt-get clean

rm -rf /var/lib/apt/lists/*

virtualenv /opt/eduid
/opt/eduid/bin/pip install -U pip
/opt/eduid/bin/pip install -r /opt/eduid/base_requirements.txt
/opt/eduid/bin/pip freeze

addgroup --system eduid

adduser --system --shell /bin/false eduid

mkdir -p /var/log/eduid
chown eduid: /var/log/eduid
chmod 770 /var/log/eduid
