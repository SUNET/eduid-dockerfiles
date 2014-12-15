#!/bin/sh

service rabbitmq-server start

set -x

rabbitmqctl add_user eduid eduid_pw

rabbitmqctl add_vhost msg
rabbitmqctl set_permissions -p msg eduid ".*" ".*" ".*"

rabbitmqctl add_vhost am
rabbitmqctl set_permissions -p am eduid ".*" ".*" ".*"

tail -f /var/log/rabbitmq/*
