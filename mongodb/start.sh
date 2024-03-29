#!/bin/bash

dbconfig=/etc/mongod.conf
pidfile=/var/run/mongodb.pid
port=${PORT-'27017'}

chown -R mongodb:mongodb /data /var/log/mongodb

if [ -s /opt/eduid/etc/mongod.conf ]; then
   dbconfig=/opt/eduid/etc/mongod.conf
fi

if [ "x$REPLSET" != "x" ]; then
    mongo_args="--config ${dbconfig} --replSet rs0 --bind_ip 0.0.0.0 --port ${port} --dbpath /data --logpath /var/log/mongodb/mongodb.log"
else
    mongo_args="--config ${dbconfig} --bind_ip 0.0.0.0 --port ${port} --dbpath /data --logpath /var/log/mongodb/mongodb.log"
fi

if  [[ -s /opt/eduid/db-scripts/db_setup.py && -s /opt/eduid/db-scripts/local.yaml ]]; then
    echo "$0: Starting mongodb for db_setup.py"
    /sbin/start-stop-daemon --start -c mongodb:mongodb --background \
        --make-pidfile --pidfile $pidfile \
        --exec /usr/bin/mongod -- $mongo_args
    sleep 2
    echo "$0: Creating users and initializing databases using /opt/eduid/db-scripts/db_setup.py"
    if [ "x$REPLSET" != "x" ]; then
        /opt/eduid/bin/python /opt/eduid/db-scripts/db_setup.py --replset rs0
    else
        /opt/eduid/bin/python /opt/eduid/db-scripts/db_setup.py
    fi
    echo "$0: Stopping mongodb after running db_setup.py"
    /sbin/start-stop-daemon --stop -c mongodb:mongodb --pidfile $pidfile \
        --remove-pidfile
    sleep 10
else
    echo "$0: /opt/eduid/db-scripts/db_setup.py not executable or /opt/eduid/db-scripts/local.yaml does not exist"
fi

echo "$0: Starting mongod into background"
exec /sbin/start-stop-daemon --start -c mongodb:mongodb \
    --make-pidfile --pidfile $pidfile \
    --exec /usr/bin/mongod -- $mongo_args
