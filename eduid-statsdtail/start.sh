#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

pip freeze

/opt/eduid/bin/statsdtail $@
