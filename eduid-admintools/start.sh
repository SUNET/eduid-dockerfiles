#!/bin/sh

. /opt/eduid/bin/activate

test -f /root/.mongo_credentials && . /root/.mongo_credentials

exec $*
