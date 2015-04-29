#!/bin/bash

set -e
set -x

apt-get clean
rm -rf /var/lib/apt/lists/*

/opt/eduid/bin/pip install pypiserver passlib

/opt/eduid/bin/pip freeze
