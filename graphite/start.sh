#!/bin/bash

set -e
set -x

mkdir -p /var/log/supervisor
touch /supervisord.{log,pid}
chown -R _graphite: /var/lib/graphite-api /var/log/graphite-api /var/lib/graphite/whisper

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
