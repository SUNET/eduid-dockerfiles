#!/bin/bash

set -e
set -x

apt-get update
apt-get -y install \
    php-fpm \
    fcgiwrap \
    supervisor \
    nagios3 \
    libjson-perl \
    liburi-perl \
    libmonitoring-plugin-perl \
    libnagios-plugin-perl \
    nagios-nrpe-plugin \
    nagios-plugins-contrib \
    nsca-client \
    sendemail \
    curl

apt-get clean
rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.nordu.net/simple/"
ping -c 1 -q pypiserver.docker && PYPI="http://pypiserver.docker:8080/simple/"

echo "#############################################################"
echo "$0: Using PyPi URL ${PYPI}"
echo "#############################################################"

/opt/eduid/bin/pip install -i ${PYPI} jose
/opt/eduid/bin/pip install -i ${PYPI} requests

/opt/eduid/bin/pip freeze

# add symlinks for the files being accessed using php-fpm (using wacky paths
# that I failed to rewrite in nginx config -- ft@)
mkdir /www
ln -s /usr/share/nagios3/htdocs /www/nagios3
#mkdir /www/cgi-bin
#ln -s /usr/lib/cgi-bin/nagios3 /www/cgi-bin/nagios3
