#!/bin/bash

set -e
set -x

mkdir -p /var/log/supervisor
touch /supervisord.{log,pid}
chown -R _graphite: /var/lib/graphite /var/log/graphite /var/lib/graphite/whisper

# create sqlite db if it doens't exist
test -s /var/lib/graphite/graphite.db && python3 /usr/bin/graphite-manage migrate --run-syncdb

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
