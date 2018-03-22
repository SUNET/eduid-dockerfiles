#!/bin/bash

HAPROXYCFG=${HAPROXYCFG-'/etc/haproxy/haproxy.cfg'}
HAPROXYWAITIF=${HAPROXYWAITIF-'20'}
HAPROXYWAITCFG=${HAPROXYWAITCFG-'10'}

if [[ $WAIT_FOR_INTERFACE ]]; then
    for i in $(seq ${HAPROXYWAITIF}); do
	ip link ls dev "$WAIT_FOR_INTERFACE" | grep -q 'state UP' && break
	echo "$0: Waiting for interface ${WAIT_FOR_INTERFACE} (${i}/${HAPROXYWAITIF})"
	sleep 1
    done

    if ! ip link ls dev "$WAIT_FOR_INTERFACE" | grep -q 'state UP'; then
	echo "$0: Interface ${WAIT_FOR_INTERFACE} not found after ${HAPROXYWAITIF} seconds"
	exit 1
    fi

    echo "$0: Interface ${WAIT_FOR_INTERFACE} is UP:"
    ip addr list "$WAIT_FOR_INTERFACE"
fi

for i in $(seq ${HAPROXYWAITCFG}); do
    test -f "${HAPROXYCFG}" && break
    echo "$0: Waiting for haproxy config file ${HAPROXYCFG} (${i}/${HAPROXYWAITCFG})"
    sleep 1
done

if [ ! -f "${HAPROXYCFG}" ]; then
    echo "$0: haproxy config not found after ${HAPROXYWAITCFG} seconds: ${HAPROXYCFG}"
    exit 1
fi


echo "$0: Checking config: ${HAPROXYCFG}"

/usr/sbin/haproxy -c -f "${HAPROXYCFG}"

echo "$0: Config ${HAPROXYCFG} checked OK, starting haproxy-systemd-wrapper"
/usr/sbin/haproxy-systemd-wrapper -p /run/haproxy.pid -f "${HAPROXYCFG}" &

while [ 1 ]; do
    echo "$0: Waiting for ${HAPROXYCFG} to be moved-to"

    # Block until an inotify event says that the config file was replaced
    inotifywait -e moved_to "${HAPROXYCFG}"

    echo "$0: Move-to event triggered, checking config: ${HAPROXYCFG}"
    config_ok=1
    /usr/sbin/haproxy -c -f "${HAPROXYCFG}" || config_ok=0
    if [ $config_ok = 1 ]; then
	echo "$0: Config ${HAPROXYCFG} checked OK, gracefully restarting haproxy-systemd-wrapper"
	/usr/sbin/haproxy $* -p /run/haproxy.pid -f "${HAPROXYCFG}" -sf `cat /run/haproxy.pid`
	echo "$0: haproxy gracefully reloaded"
    else
	echo "$0: Config ${HAPROXYCFG} NOT OK"
    fi
    sleep 1  # spin control
done
