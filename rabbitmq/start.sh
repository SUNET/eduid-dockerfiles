#!/bin/sh

service rabbitmq-server start

set -x

# Set up admin user with web interface access
rabbitmqctl add_user admin password
rabbitmqctl set_permissions admin ".*" ".*" ".*"
rabbitmqctl set_user_tags admin administrator

# Set up general 'eduid' user
rabbitmqctl add_user eduid eduid_pw

# Set up virtualhosts
for vh in msg am; do
    rabbitmqctl add_vhost ${vh}
    rabbitmqctl set_permissions -p ${vh} eduid ".*" ".*" ".*"
    rabbitmqctl set_permissions -p ${vh} admin ".*" ".*" ".*"
done

tail -f /var/log/rabbitmq/*
