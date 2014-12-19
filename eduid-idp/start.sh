#!/bin/sh

set -e

. /opt/eduid/bin/activate

chown eduid: /var/log/eduid

# Create metadata
cd /opt/eduid/etc && /opt/eduid/bin/make_metadata.py idp_conf.py | xmllint --format - > idp_metadata.xml

run=/opt/eduid/bin/eduid_idp
if [ -x /opt/eduid/src/src/eduid_idp/idp.py ]; then
    run=/opt/eduid/src/src/eduid_idp/idp.py
fi

start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/python -- $run \
    --config-file /opt/eduid/etc/idp.ini \
    --debug

echo $0: Exiting
