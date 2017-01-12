#!/bin/sh

set -e
set -x

. /opt/eduid/bin/activate

# this is a Python module name, so can't have hyphen (also name of .ini file)
app_name=$(echo $eduid_name | tr "-" "_")
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
cfg_dir=${cfg_dir-"${base_dir}/etc"}
ini=${ini-"${cfg_dir}/${app_name}.ini"}
log_dir=${log_dir-'/var/log/eduid'}
var_dir=${var_dir-'/var/lib/softhsm'}
logfile=${logfile-"${log_dir}/${eduid_name}.log"}

PYELEVEN_ARGS=${PYELEVEN_ARGS-'-w2 --user eduid --group softhsm --reload'}
PYELEVEN_PORT=${PYELEVEN_PORT-'8000'}
PKCS11PIN=${PKCS11PIN-'1234'}
PKCS11SOPIN=${PKCS11SOPIN-'123456'}

if [ ! -d "${var_dir}/tokens" ]; then
    echo "$0: Initializing SoftHSM token"
    mkdir /var/lib/softhsm/tokens
    softhsm2-util --init-token --slot 0 --label "py11softhsm token 1" --pin "${PKCS11PIN}" --so-pin "${PKCS11SOPIN}"
fi

chown -R eduid: "${log_dir}" "${var_dir}"

#touch "${logfile}"
#chgrp eduid "${logfile}"
#chmod 660 "${logfile}"

cat>/config.py<<EOF
DEBUG = True
PKCS11MODULE = "/usr/lib/x86_64-linux-gnu/softhsm/libsofthsm2.so"
PKCS11PIN = "${PKCS11PIN}"
EOF

echo "$0: Starting Gunicorn app pyeleven:app"
exec gunicorn -b "0.0.0.0:${PYELEVEN_PORT}" ${PYELEVEN_ARGS} pyeleven:app
