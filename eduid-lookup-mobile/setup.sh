#!/bin/bash

set -e

/opt/eduid/bin/pip install --pre -i https://pypi.nordu.net/simple/ eduid_lookup_mobile

/opt/eduid/bin/pip freeze
