#!/bin/sh

set -e

. /opt/eduid/bin/activate

dashboard_cfg_dir=${dashboard_cfg_dir-'/opt/eduid/etc/eduid-dashboard'}
dashboard_log_dir=${dashboard_log_dir-'/var/log/eduid'}
dashboard_state_dir=${dashboard_state_dir-'/opt/eduid/run'}
dashboard_metadata=${dashboard_metadata-"${dashboard_state_dir}/dashboard_metadata.xml"}
dashboard_ini=${dashboard_ini-"${dashboard_cfg_dir}/eduid-dashboard.ini"}
dashboard_pysaml2_settings=${dashboard_pysaml2_settings-"${dashboard_cfg_dir}/dashboard_pysaml2_settings.py"}

chown eduid: "${dashboard_log_dir}" "${dashboard_state_dir}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${dashboard_ini}" || true
chmod 640 "${dashboard_ini}" || true

if [ ! -s "${dashboard_metadata}" ]; then
    # Create file with local metadata
    cd "${dashboard_cfg_dir}" && \
	/opt/eduid/bin/make_metadata.py "${dashboard_pysaml2_settings}" | \
	xmllint --format - > "${dashboard_metadata}"
fi

pserve_args=""
if [ -f /opt/eduid/src/setup.py ]; then
    pserve_args="--reload --monitor-restart"
fi

echo "$0: pserving ${dashboard_ini}"
start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/pserve -- "${dashboard_ini}" \
     --pid-file "${dashboard_state_dir}/eduid-dashboard.pid" \
     --log-file "${dashboard_log_dir}/eduid-dashboard.log" \
    --user=eduid --group=eduid $pserve_args

echo $0: Exiting
