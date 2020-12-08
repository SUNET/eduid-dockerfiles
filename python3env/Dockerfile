FROM debian:stable

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN mkdir -p /opt/eduid
COPY setup.sh /opt/eduid/setup.sh
COPY base_requirements.txt /opt/eduid/base_requirements.txt
RUN /opt/eduid/setup.sh

VOLUME ["/opt/eduid/etc", "/var/log/eduid"]

WORKDIR /
