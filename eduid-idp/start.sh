#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

idp_cfg_dir=${idp_cfg_dir-'/opt/eduid/etc/eduid-idp'}
idp_log_dir=${idp_log_dir-'/var/log/eduid'}
idp_state_dir=${idp_state_dir-'/opt/eduid/run'}
idp_metadata=${idp_metadata-"${idp_state_dir}/idp_metadata.xml"}
idp_ini=${idp_ini-"${idp_cfg_dir}/eduid-idp.ini"}
idp_pysaml2_settings=${idp_pysaml2_settings-"${idp_cfg_dir}/idp_pysaml2_settings.py"}

chown eduid: "${idp_log_dir}" "${idp_state_dir}"

if [ ! -s "${idp_metadata}" ]; then
    # Create file with local metadata
    cd "${idp_cfg_dir}" && \
	/opt/eduid/bin/make_metadata.py "${idp_pysaml2_settings}" | \
	xmllint --format - > "${idp_metadata}"
fi

run=/opt/eduid/bin/eduid_idp
if [ -x /opt/eduid/src/src/eduid_idp/idp.py ]; then
    run=/opt/eduid/src/src/eduid_idp/idp.py
fi

echo "$0: Starting ${run} with config ${idp_ini}"
start-stop-daemon --start -c eduid:eduid --exec \
     /opt/eduid/bin/python -- $run \
    --config-file ${idp_ini} \
    --debug

echo $0: Exiting
