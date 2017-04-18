#!/bin/bash

dbconfig=/etc/mongodb.conf
pidfile=/var/run/mongodb.pid

chown -R mongodb:mongodb /data /var/log/mongodb

echo "$0: Starting mongod into background"

if [ -s /opt/eduid/etc/mongodb.conf ]; then
   dbconfig=/opt/eduid/etc/mongodb.conf
fi


if [ -x /opt/eduid/db-scripts/createUsers.sh ]; then
    echo "$0: Starting mongodb for createUsers.sh"
    /sbin/start-stop-daemon --start -c mongodb:mongodb --background \
        --make-pidfile --pidfile $pidfile \
        --exec /usr/bin/mongod -- \
        --config $dbconfig \
        --dbpath /data --logpath /var/log/mongodb/mongodb.log
    sleep 2
    echo "$0: Creating eduid users using /opt/eduid/db-scripts/createUsers.sh"
    /opt/eduid/db-scripts/createUsers.sh
    echo "$0: Stopping mongodb after createUsers.sh"
    /sbin/start-stop-daemon --stop -c mongodb:mongodb --pidfile $pidfile \
        --remove-pidfile
    sleep 2
else
    echo "$0: /opt/eduid/db-scripts/createUsers.sh not executable"
fi

exec /sbin/start-stop-daemon --start -c mongodb:mongodb \
    --make-pidfile --pidfile $pidfile \
    --exec /usr/bin/mongod -- \
    --config $dbconfig \
    --dbpath /data --logpath /var/log/mongodb/mongodb.log
