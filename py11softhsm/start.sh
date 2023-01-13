#!/bin/bash

set -e
set -x

eduid_name=${eduid_name-'py11softhsm'}
log_dir=${log_dir-'/var/log/eduid'}
var_dir=${var_dir-'/var/lib/softhsm'}
logfile=${logfile-"${log_dir}/${eduid_name}.log"}
import_keys_file=${import_keys_file-'/keys.txt'}

PYELEVEN_ARGS=${PYELEVEN_ARGS-'-w2 --user eduid --group softhsm --reload'}
PYELEVEN_PORT=${PYELEVEN_PORT-'8000'}

# Export these for use in import-key.sh
PKCS11MODULE=${PKCS11MODULE-'/usr/lib/softhsm/libsofthsm2.so'}
PKCS11PIN=${PKCS11PIN-'1234'}
PKCS11SOPIN=${PKCS11SOPIN-'123456'}
export PKCS11MODULE PKCS11PIN PKCS11SOPIN

mkdir -p "${var_dir}/tokens"

echo "$0: Extra debug: Objects in SoftHSM before init:"
pkcs11-tool --module "${PKCS11MODULE}" --login --pin "${PKCS11PIN}" --list-objects || true

if [ -f "${import_keys_file}" ]; then
    echo "$0: Importing keys from ${import_keys_file}:"
    cat "${import_keys_file}"
    echo "(end of ${import_keys_file})"
    grep -ve '^#' -e '^\s*$' "${import_keys_file}" | while read -r line; do
        # shellcheck disable=SC2086
        /import-key.sh ${line}
    done
fi

echo -e "\n\n---"
echo "$0: Objects in SoftHSM:"
pkcs11-tool --module /usr/lib/softhsm/libsofthsm2.so --login --pin 1234 --list-token-slots || true
echo "---"
pkcs11-tool --module "${PKCS11MODULE}" --login --pin "${PKCS11PIN}" --list-objects || true
echo -e "---\n\n"

chown -R eduid: "${log_dir}"
chown -R eduid:softhsm "${var_dir}" /etc/softhsm
find "${var_dir}" -type d -print0 | xargs -0 chmod 750
find "${var_dir}" -type f -print0 | xargs -0 chmod 640

if [ "x$ENABLE_PKCS11_SPY" != "x" ]; then
    echo "$0: Enabling pkcs11-spy since \$ENABLE_PKCS11_SPY is set"
    PKCS11SPY="${PKCS11MODULE}"
    PKCS11MODULE='/usr/lib/x86_64-linux-gnu/pkcs11-spy.so'
    export PKCS11SPY
fi

cat>/config.py<<EOF
DEBUG = True
PKCS11MODULE = "${PKCS11MODULE}"
PKCS11PIN = "${PKCS11PIN}"
EOF

. /opt/eduid/bin/activate

echo "$0: Starting Gunicorn app pyeleven:app"
exec gunicorn -b "0.0.0.0:${PYELEVEN_PORT}" ${PYELEVEN_ARGS} pyeleven:app
