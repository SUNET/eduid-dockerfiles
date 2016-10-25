#!/bin/sh

set -e
set -x

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-mm-service'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
mm_keystore_name=${mm_keystore_name-'eduid.se'}
mm_etcdir=${mm_etcdir-"${base_dir}/etc"}
mm_state_dir=${mm_state_dir-"${base_dir}/run"}
mm_cert_file=${mm_cert_file-"${mm_etcdir}/mm.crt"}
mm_key_file=${mm_key_file-"${mm_etcdir}/mm.key"}
mm_keystore_file=${mm_keystore_file-"${mm_state_dir}/mm_keystore.p12"}
mm_ca_cert_file=${mm_ca_cert_file-"${mm_etcdir}/Steria-AB-EID-CA-v2.cer"}
mm_truststore_file=${mm_truststore_file-"${mm_state_dir}/mm_truststore.jks"}
mm_key_p8_file=${mm_key_p8_file-"${mm_state_dir}/mm_key.p8"}

mm_properties=${mm_properties-"${mm_etcdir}/mm-service.properties"}
mm_jarfile=${mm_jarfile-'/opt/eduid/eduid-mm-service-0.1-SNAPSHOT.jar'}

# Variables mm_truststore_file and mm_keystore_file are required when generating truststore and keystore

chown eduid: "${mm_state_dir}"

ls -l "${mm_etcdir}"

if [ ! -s "${mm_truststore_file}" ]; then
    echo "$0: Creating Java truststore file ${mm_truststore_file}"

    if [ "x${mm_truststore_pw}" = "x" ]; then
	echo "$0: ERROR: mm_truststore_pw not set."
	exit 1
    fi

    ls -l "${mm_ca_cert_file}"
    (umask 077; keytool -import -trustcacerts -alias root \
	-file "${mm_ca_cert_file}" -keystore "${mm_truststore_file}" \
	-deststorepass "${mm_truststore_pw}" -noprompt)
fi

if [ ! -s "${mm_keystore_file}" ]; then
    echo "$0: Creating Java keystore file (p12) ${mm_keystore_file}"

    if [ "x${mm_keystore_pw}" = "x" ]; then
	echo "$0: ERROR: mm_keystore_pw not set."
	exit 1
    fi

    ls -l "${mm_key_file}" "${mm_cert_file}"
    (umask 077; openssl pkcs12 -export -inkey "${mm_key_file}" \
	-in "${mm_cert_file}" -out "${mm_keystore_file}" \
	-name "${mm_keystore_name}" -passout pass:"${mm_keystore_pw}")
fi

if [ ! -s "$mm_key_p8_file" ]; then
    echo "$0: Setting up p8-file $mm_key_p8_file (from ${mm_key_file})"
    ls -l "${mm_key_file}"
    (umask 077; openssl pkcs8 -topk8 -inform PEM -in "${mm_key_file}" \
	-outform DER -out "${mm_key_p8_file}" -nocrypt)
fi

chown root:eduid "${mm_truststore_file}" "${mm_keystore_file}" "${mm_key_p8_file}"
chmod 640 "${mm_truststore_file}" "${mm_keystore_file}" "${mm_key_p8_file}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${mm_properties}" || true
chmod 640 "${mm_properties}" || true

echo "$0: Starting JAR ${mm_jarfile} (properties file: ${mm_properties})"
exec start-stop-daemon --start --quiet -c eduid:eduid \
     --pidfile "${state_dir}/${eduid_name}.pid" --make-pidfile \
     --exec /usr/bin/java -- -jar "${mm_jarfile}" -c "${mm_properties}"
