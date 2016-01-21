#!/bin/bash

echo "$0: Starting redis into background"

redis-server /opt/eduid/etc/redis.conf

sleep 2

tail -F /var/log/redis/redis-server.log
