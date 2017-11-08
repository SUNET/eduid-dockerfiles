#!/bin/sh

set -e
set -x

rsysloguser=${rsysloguser-'syslog'}
rsysloggroup=${rsysloggroup-'syslog'}
logdir=${logdir-'/var/log/eduid'}
run=${run-'/usr/sbin/rsyslogd'}
extra_args=${extra_args-''}

test -d ${logdir} || (mkdir -p ${logdir}; chgrp ${rsysloggroup} ${logdir}; chmod 775 ${logdir})

for dir in ${logdir}; do
    test -d ${dir} && chgrp ${rsysloggroup} ${dir} && chmod 775 ${dir}
done


echo ""
echo "$0: Starting ${run} with args: -n ${extra_args}"
exec ${run} -n ${extra_args}
