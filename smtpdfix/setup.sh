#!/bin/sh

set -e

python -m venv /venv
/venv/bin/pip install -U pip
/venv/bin/pip install smtpdfix

mkdir /data
