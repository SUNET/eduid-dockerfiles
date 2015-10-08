#!/bin/sh

set -e
set -x

# These could be set from Puppet if multiple instances are deployed
eduid_name=${eduid_name-'eduid-navet-service'}
base_dir=${base_dir-"/opt/eduid/${eduid_name}"}
# These *can* be set from Puppet, but are less expected to...
navet_keystore_name=${navet_keystore_name-'eduid.se'}
navet_etcdir=${navet_etcdir-"${base_dir}/etc"}
navet_state_dir=${navet_state_dir-"${base_dir}/run"}
navet_cert_file=${navet_cert_file-"${navet_etcdir}/navet.crt"}
navet_key_file=${navet_key_file-"${navet_etcdir}/navet.key"}
navet_keystore_file=${navet_keystore_file-"${navet_state_dir}/navet_keystore.p12"}
navet_ca_cert_file=${navet_ca_cert_file-"${navet_etcdir}/Steria-AB-EID-CA-v2.cer"}
navet_intermediate_cert_file1=${navet_intermediate_cert_file1-"${navet_etcdir}/VeriSign.cer"}
navet_intermediate_cert_file2=${navet_intermediate_cert_file2-"${navet_etcdir}/Symantec.cer"}
navet_truststore_file=${navet_truststore_file-"${navet_state_dir}/mm_truststore.jks"}

navet_properties=${navet_properties-"${navet_etcdir}/navet-service.properties"}
navet_jar_file=${navet_jar_file-'/opt/eduid/eduid-navet-service-0.1-SNAPSHOT.jar'}

# Variables mm_truststore_file and mm_keystore_file are required when generating truststore and keystore

chown eduid: "${navet_state_dir}"

ls -l "${navet_etcdir}"

if [ ! -s "${navet_truststore_file}" ]; then
    echo "$0: Creating Java truststore file ${navet_truststore_file}"

    if [ "x${navet_truststore_pw}" = "x" ]; then
        echo "$0: ERROR: navet_truststore_pw not set."
        exit 1
    fi

    ls -l "${navet_ca_cert_file}"
    (umask 077; keytool -import -trustcacerts -alias root \
    -file "${navet_ca_cert_file}" -keystore "${navet_truststore_file}" \
    -deststorepass "${navet_truststore_pw}" -noprompt)

    ls -l "${navet_intermediate_cert_file1}"
    (umask 077; keytool -import -trustcacerts -alias inter1 \
    -file "${navet_intermediate_cert_file1}" -keystore "${navet_truststore_file}" \
    -deststorepass "${navet_truststore_pw}" -noprompt)

    ls -l "${navet_intermediate_cert_file2}"
    (umask 077; keytool -import -trustcacerts -alias inter2 \
    -file "${navet_intermediate_cert_file2}" -keystore "${navet_truststore_file}" \
    -deststorepass "${navet_truststore_pw}" -noprompt)
fi

if [ ! -s "${navet_keystore_file}" ]; then
    echo "$0: Creating Java keystore file (p12) ${navet_keystore_file}"

    if [ "x${navet_keystore_pw}" = "x" ]; then
        echo "$0: ERROR: mm_keystore_pw not set."
        exit 1
    fi

    ls -l "${navet_key_file}" "${navet_cert_file}"
    (umask 077; openssl pkcs12 -export -inkey "${navet_key_file}" \
    -in "${navet_cert_file}" -out "${navet_keystore_file}" \
    -name "${navet_keystore_name}" -passout pass:"${navet_keystore_pw}")
fi

chown root:eduid "${navet_truststore_file}" "${navet_keystore_file}"
chmod 640 "${navet_truststore_file}" "${navet_keystore_file}"

# || true to not fail on read-only cfg_dir
chgrp eduid "${navet_properties}" || true
chmod 640 "${navet_properties}" || true

echo "$0: Starting JAR ${navet_jar_file} (properties file: ${navet_properties})"
exec start-stop-daemon --start -c eduid --exec /usr/bin/java -- -jar "${navet_jar_file}" -c "${navet_properties}"
