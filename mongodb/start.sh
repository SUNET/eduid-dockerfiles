#!/bin/bash

echo "$0: Starting mongod into background"

/usr/bin/mongod --config /opt/eduid/etc/mongodb.conf &

sleep 2

if [ -x /opt/eduid/db-scripts/createUsers.sh ]; then
    echo "$0: Creating eduid users using /opt/eduid/db-scripts"
    /opt/eduid/db-scripts/createUsers.sh
else
    echo "$0: /opt/eduid/db-scripts/createUsers.sh not executable"
fi

tail -F /var/log/mongodb/mongodb.log
