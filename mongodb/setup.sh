#!/bin/bash

set -e

python3 -m venv /opt/eduid
/opt/eduid/bin/pip install -U pip wheel
# for the db-scripts
/opt/eduid/bin/pip install -i https://pypi.sunet.se/simple/ "pymongo>=3.6.0,<4" pyyaml
