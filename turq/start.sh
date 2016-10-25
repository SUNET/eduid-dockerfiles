#!/bin/sh

set -e

. /opt/eduid/bin/activate

exec start-stop-daemon --start -c eduid:eduid --exec /run_turq
