#!/bin/bash

set -e
set -x

apt-get update
apt-get -y install \
    php-fpm \
    fcgiwrap \
    supervisor \
    icinga \
    libjson-perl \
    liburi-perl \
    libmonitoring-plugin-perl \
    nagios-nrpe-plugin \
    nagios-plugins-contrib \
    nsca-client \
    sendemail \
    curl \
    rsync \
    net-tools

#    libnagios-plugin-perl \

apt-get clean
rm -rf /var/lib/apt/lists/*

PYPI="https://pypi.sunet.se/simple/"
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
ln -s /usr/share/icinga/htdocs /www/icinga
#mkdir /www/cgi-bin
#ln -s /usr/lib/cgi-bin/icinga /www/cgi-bin/icinga

# preserve /etc/icinga/stylesheets, that start.sh will untar in /icinga_data/
# in order for the files to eventually reach the nginx container. ugh.
(cd /etc/icinga && tar zcf /stylesheets.tar.gz stylesheets)
