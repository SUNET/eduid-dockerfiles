#!/bin/bash

set -e

apt-get -y install \
    git-core \
    nginx

# make sure we get rid of all default sites
rm -f /etc/nginx/sites-enabled/*
# sym-link the config we want
ln -s /opt/eduid/sites-available/html.conf /etc/nginx/sites-enabled/html.conf

# Get the data from github
mkdir -p /opt/eduid/src/
cd /opt/eduid/src/
git clone https://github.com/SUNET/eduid-html.git
# tmp change branch
cd eduid-html
git checkout tmp_new_design

# save space
rm -rf /var/lib/apt/lists/*

echo -e "\ndaemon off;" >> /etc/nginx/nginx.conf
