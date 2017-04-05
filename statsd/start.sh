#!/bin/bash

graphite_host=${GRAPHITE_HOST-'graphite'}
graphite_port=${GRAPHITE_PORT-'2003'}
statsd_port=${STATSD_PORT-'8125'}
statsd_cfg=${STATSD_CFG-'/statsd/config.js'}

# intentionally not $statsd_cfg
if [ ! -s /statsd/config.js ]; then
    cat > /statsd/config.js <<EOF
(function() {
    return {
        graphitePort: parseInt(process.env.GRAPHITE_PORT) || ${graphite_port},
        graphiteHost: process.env.GRAPHITE_HOST || "${graphite_host}",
        port: parseInt(process.env.STATSD_PORT) || ${statsd_port},
        backends: [ "./backends/graphite" ],
        flushInterval: parseInt(process.env.FLUSH_INTERVAL) || 60000,
        dumpMessages: true,
        debug: true
    };
})()
EOF
fi

exec nodejs /statsd/stats.js $statsd_cfg
