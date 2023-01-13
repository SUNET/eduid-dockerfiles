#!/bin/bash
# TEST
#
# Import a secret key into SoftHSM, if it isn't already present.
#
# PKCS#11 objects are organised like this:
#
#  - Slots
#    - Tokens
#      - Objects (e.g. keys)
#
# Slots are 'partitions', and we don't use that.
#

set -e

token_label=${1}
key_id_hex=${2}
key_label=${3}
keyfile=${4}

if [ -z "${token_label}" ] || [ -z "${key_id_hex}" ] || [ -z "${key_label}" ] || [ -z "${keyfile}" ]; then
    echo "Syntax: $0 <token_label> <key_id_hex> <key_label> <keyfile>"
    exit 1
fi

if [ -z "${PKCS11MODULE}" ] || [ -z "${PKCS11PIN}" ] || [ -z "${PKCS11SOPIN}" ]; then
    echo "$0: PKCS11MODULE, PKCS11PIN or PKCS11SOPIN not set"
    exit 1
fi


if [ ! -f "${keyfile}" ]; then
    echo "$0: Key file ${keyfile} not found"
    exit 1
fi

#
# Create token if it doesn't exist
#

if ! pkcs11-tool --module "${PKCS11MODULE}" --login --pin "${PKCS11PIN}" \
        --list-slots 2>/dev/null | grep -qE "^\s*token label\s*:\s+${token_label}"; then
    echo "$0: Token ${token_label} not found, creating it"
    softhsm2-util --init-token --free --label "${token_label}" --pin "${PKCS11PIN}" --so-pin "${PKCS11SOPIN}"
fi

#
# Import the key into the token
#

if ! pkcs11-tool --module "${PKCS11MODULE}" --login --pin "${PKCS11PIN}" \
        --list-objects 2>/dev/null | grep -qE "^\s*label\s*:\s+${key_label}"; then

    echo "$0: Importing key token=${token_label}/id=${key_id_hex}/key=${key_label} from ${keyfile}"

    # Convert PEM formatted secret key to DER format, for SoftHSM
    tmpkey=$(mktemp --tmpdir=/dev/shm import-key-XXXXXX.p8)
    chmod 600 "${tmpkey}"
    openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in "${keyfile}" -out "${tmpkey}"

    softhsm2-util --import "${tmpkey}" --token "${token_label}" --label "${key_label}" \
            --id "${key_id_hex}" --pin "${PKCS11PIN}" --no-public-key

    rm "${tmpkey}"
else
    echo "$0: Key token=${token_label}/id=${key_id_hex}/key=${key_label} already present"
fi
