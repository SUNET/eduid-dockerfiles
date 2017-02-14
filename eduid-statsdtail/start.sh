#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

/opt/eduid/bin/statsdtail $@
