#!/bin/bash

set -e

# Set exec bit on build script
chmod 755 /opt/eduid/build.sh

# Pre-install common or slow Python packages
/opt/eduid/bin/pip install -U setuptools
/opt/eduid/bin/pip install nose nosexcover pylint


