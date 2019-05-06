FROM debian:testing

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN mkdir -p /opt/eduid
COPY setup.sh /opt/eduid/setup.sh
COPY base_requirements.txt /opt/eduid/base_requirements.txt
RUN /opt/eduid/setup.sh

# Workaround for XXE found in libxml2
# The following deb:s are from Debian experimental
# and at least fixes the problem that I could reproduce
# manually with the old version of libxml2.
# For more info:
# https://bugzilla.gnome.org/show_bug.cgi?id=772726
COPY *.deb /opt/eduid/deb/
RUN dpkg -i /opt/eduid/deb/*

VOLUME ["/opt/eduid/etc", "/var/log/eduid"]

WORKDIR /
