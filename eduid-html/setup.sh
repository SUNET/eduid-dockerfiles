#!/bin/bash

set -e

apt-get -y install \
    git-core \
    nginx

# make sure we get rid of all default sites
rm -f /etc/nginx/sites-enabled/*

# Get the data from github
mkdir -p /opt/eduid/eduid-html/
cd /opt/eduid/eduid-html/
git clone https://github.com/SUNET/eduid-html.git wwwroot

# save space
rm -rf /var/lib/apt/lists/*
rm -f /opt/eduid/eduid-html/wwwroot/Gruntfile.js
rm -f /opt/eduid/eduid-html/wwwroot/package.json
rm -rf /opt/eduid/eduid-html/wwwroot/assets/sass/

echo -e "\ndaemon off;" >> /etc/nginx/nginx.conf
