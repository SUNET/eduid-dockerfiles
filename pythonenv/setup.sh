#!/bin/bash

set -e

virtualenv /opt/eduid
/opt/eduid/bin/pip install -U pip

addgroup --system eduid

adduser --system --shell /bin/false eduid

mkdir -p /var/log/eduid
chown eduid: /var/log/eduid
chmod 770 /var/log/eduid
