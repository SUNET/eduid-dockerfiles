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
      libpython3-dev \
      python3-cffi \
      python3-venv \
      libssl-dev \
      libxml2-dev \
      libxslt1-dev \
      xmlsec1 \
      libxml2-utils \
      iputils-ping \
      procps \
      bind9-host \
      netcat-openbsd \
      net-tools \
      curl \
    && apt-get clean

rm -rf /var/lib/apt/lists/*

python3 -m venv /opt/eduid
/opt/eduid/bin/pip install -U pip
/opt/eduid/bin/pip install --no-cache-dir -r /opt/eduid/base_requirements.txt
/opt/eduid/bin/pip freeze

addgroup --system eduid

adduser --system --shell /bin/false eduid

mkdir -p /var/log/eduid
chown eduid: /var/log/eduid
chmod 770 /var/log/eduid
