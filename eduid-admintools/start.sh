#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

exec python $*
