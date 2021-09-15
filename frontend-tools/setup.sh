#!/bin/bash

set -e
set -x

PYPI="https://pypi.sunet.se/simple/"

apt-get update
apt-get -y --no-install-recommends install \
	python3-jinja2 \
	python3-yaml \
	python3-requests \
	python3-venv \
	python3-pip \
	inotify-tools \
	procps \
	net-tools \
	socat \
	curl \
	git
apt-get clean
rm -rf /var/lib/apt/lists/*

python3 -m venv /opt/frontend
/opt/frontend/bin/pip3 install -i ${PYPI} haproxy-status
/opt/frontend/bin/pip3 install -i ${PYPI} PyYAML

git clone https://github.com/SUNET/sarimner-frontend /opt/sarimner
# preserve info about what was cloned in the build logs
(cd /opt/sarimner; git show --oneline -s --show-signature)
cp -a /opt/sarimner/scripts /opt/frontend/scripts
