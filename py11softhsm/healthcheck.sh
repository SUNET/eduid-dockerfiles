#!/bin/bash

exec curl -X POST http://localhost:8000/healthcheck/healthcheck_key/rawsign \
    -H 'Content-Type: application/json' \
    -d '{"data": "dGVzdAo=" }' \
    2>/dev/null | grep -q 'signed'
