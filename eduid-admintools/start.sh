#!/bin/sh

. /opt/eduid/webapp/bin/activate

test -f /root/.mongo_credentials && . /root/.mongo_credentials

exec $*
