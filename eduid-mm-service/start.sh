#!/bin/sh

set -e

mm_keystore_name=${mm_keystore_name-'eduid.se'}
mm_etcdir=${mm_etcdir-'/opt/eduid/etc/eduid_mm_service'}
mm_cert_file=${mm_cert_file-"${mm_etcdir}/mm.crt"}
mm_key_file=${mm_key_file-"${mm_etcdir}/mm.key"}
mm_keystore_file=${mm_keystore_file-"${mm_etcdir}/mm_keystore.p12"}
mm_ca_cert_file=${mm_ca_cert_file-"${mm_etcdir}/Steria-AB-EID-CA-v2.cer"}
mm_truststore_file=${mm_truststore_file-"${mm_etcdir}/mm_truststore.jks"}
mm_key_p8_file=${mm_key_p8_file-"${mm_etcdir}/mm_key.p8"}

mm_properties=${mm_properties-"${mm_etcdir}/mm-service.properties"}
mm_jarfile=${mm_jarfile-'/opt/eduid/eduid-mm-service-0.1-SNAPSHOT.jar'}

# Variables mm_truststore_file and mm_keystore_file are required when generating truststore and keystore

ls -l "${mm_etcdir}"

if [ ! -s "${mm_truststore_file}" ]; then
    echo "$0: Creating Java truststore file ${mm_truststore_file}"

    if [ "x${mm_truststore_pw}" = "x" ]; then
	echo "$0: ERROR: mm_truststore_pw not set."
	exit 1
    fi

    (umask 077; keytool -import -trustcacerts -alias root \
	-file "${mm_ca_cert_file}" -keystore "${mm_truststore_file}" \
	-deststorepass "${mm_truststore_pw}" -noprompt)
fi

if [ ! -s "${mm_keystore_file}" ]; then
    echo "$0: Creating Java keystore file (p12) ${mm_truststore_file}"

    if [ "x${mm_keystore_pw}" = "x" ]; then
	echo "$0: ERROR: mm_keystore_pw not set."
	exit 1
    fi

    (umask 077; openssl pkcs12 -export -inkey "${mm_key_file}" \
	-in "${mm_cert_file}" -out "${mm_keystore_file}" \
	-name "${mm_keystore_name}" -passout pass:"${mm_keystore_pw}")
fi

if [ ! -s "$mm_key_p8_file" ]; then
    echo "$0: Setting up p8-file $mm_key_p8_file (from ${mm_key_file})"
    (umask 077; openssl pkcs8 -topk8 -inform PEM -in "${mm_key_file}" \
	-outform DER -out "${mm_key_p8_file}" -nocrypt)
fi

chown root:eduid "${mm_truststore_file}" "${mm_keystore_file}" "${mm_key_p8_file}"
chmod 640 "${mm_truststore_file}" "${mm_keystore_file}" "${mm_key_p8_file}"

chgrp eduid "${mm_properties}"
chmod 640 "${mm_properties}"

exec start-stop-daemon --start -c eduid --exec /usr/bin/java -- -jar "${mm_jarfile}" -c "${mm_properties}"
