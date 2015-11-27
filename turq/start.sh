#!/bin/sh

set -e

. /opt/eduid/bin/activate

exec sudo -u eduid /run_turq
