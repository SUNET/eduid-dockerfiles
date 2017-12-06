#!/bin/bash

dbconfig=/etc/mongodb.conf
pidfile=/var/run/mongodb.pid

chown -R mongodb:mongodb /data /var/log/mongodb

if [ -s /opt/eduid/etc/mongodb.conf ]; then
   dbconfig=/opt/eduid/etc/mongodb.conf
fi


if [ -s /opt/eduid/db-scripts/db_setup.py -a -s /opt/eduid/db-scripts/local.yaml ]; then
    echo "$0: Starting mongodb for db_setup.py"
    /sbin/start-stop-daemon --start -c mongodb:mongodb --background \
        --make-pidfile --pidfile $pidfile \
        --exec /usr/bin/mongod -- \
        --config $dbconfig \
        --dbpath /data --logpath /var/log/mongodb/mongodb.log
    sleep 2
    echo "$0: Creating users and initializing databases using /opt/eduid/db-scripts/db_setup.py"
    /opt/eduid/bin/python /opt/eduid/db-scripts/db_setup.py
    echo "$0: Stopping mongodb after running db_setup.py"
    /sbin/start-stop-daemon --stop -c mongodb:mongodb --pidfile $pidfile \
        --remove-pidfile
    sleep 2
else
    echo "$0: /opt/eduid/db-scripts/db_setup.py not executable or /opt/eduid/db-scripts/local.yaml does not exist"
fi

echo "$0: Starting mongod into background"
exec /sbin/start-stop-daemon --start -c mongodb:mongodb \
    --make-pidfile --pidfile $pidfile \
    --exec /usr/bin/mongod -- \
    --config $dbconfig \
    --dbpath /data --logpath /var/log/mongodb/mongodb.log
