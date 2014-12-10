#!/bin/bash

set -e

virtualenv /opt/eduid

addgroup --system eduid

adduser --system --shell /bin/false eduid

mkdir -p /var/log/eduid
chown eduid: /var/log/eduid
chmod 700 /var/log/eduid
