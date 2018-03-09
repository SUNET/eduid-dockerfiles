#!/bin/sh

set -e

HAPROXYCFG=${HAPROXYCFG-'/etc/haproxy/haproxy.cfg'}

for i in $(seq 10); do
    test -f "${HAPROXYCFG}" && break
    sleep 1
done

if [ ! -f "${HAPROXYCFG}" ]; then
    logger -i -t haproxy-autoreload "haproxy config not found after 10 seconds: ${HAPROXYCFG}"
    exit 1
fi


logger -i -t haproxy-autoreload "Checking config: ${HAPROXYCFG}"

/usr/sbin/haproxy -c -f "${HAPROXYCFG}"

logger -i -t haproxy-autoreload "Config ${HAPROXYCFG} checked OK, starting haproxy-systemd-wrapper"
/usr/sbin/haproxy-systemd-wrapper -p /run/haproxy.pid -f "${HAPROXYCFG}" &

while [ 1 ]; do
    # Block until an inotify event says that the config file was replaced
    inotifywait -e moved_to "${HAPROXYCFG}"

    logger -i -t haproxy-autoreload "Move-to event triggered, checking config: ${HAPROXYCFG}"
    config_ok=1
    /usr/sbin/haproxy -c -f "${HAPROXYCFG}" || config_ok=0
    if [ $config_ok = 1 ]; then
	logger -i -t haproxy-autoreload "Config ${HAPROXYCFG} checked OK, gracefully restarting haproxy-systemd-wrapper"
	haproxy-systemd-wrapper $* -p /run/haproxy.pid -f "${HAPROXYCFG}" -sf `cat /run/haproxy.pid`
    else
	logger -i -t haproxy-autoreload "Config ${HAPROXYCFG} NOT OK"
    fi
done
