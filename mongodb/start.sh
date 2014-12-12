#!/bin/bash

echo "$0: Starting mongod into background"

/usr/bin/mongod --config /opt/eduid/etc/mongodb.conf &

sleep 2

if [ -x /data/createUsers.sh ]; then
    echo "$0: Creating eduid users"
    /data/createUsers.sh
else
    echo "$0: /data/createUsers.sh not executable"
fi

tail -F /var/log/mongodb/mongodb.log
