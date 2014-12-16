#!/bin/sh

set -e

. /opt/eduid/bin/activate

sudo -u eduid /run_turq

echo $0: Exiting
