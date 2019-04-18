FROM debian:testing

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN mkdir -p /opt/eduid
COPY setup.sh /opt/eduid/setup.sh
COPY base_requirements.txt /opt/eduid/base_requirements.txt
RUN /opt/eduid/setup.sh

# Workaround for XXE in xmlsec1 found in Debian stable.
# The following deb:s are from Debian testing:
#COPY *.deb /opt/eduid/deb/
#RUN dpkg -i /opt/eduid/deb/*

VOLUME ["/opt/eduid/etc", "/var/log/eduid"]

WORKDIR /
