FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN apt-get update && apt-get install -y \
      sed \
      git \
      build-essential \
      libpython-dev \
      python-pip \
      python-virtualenv

RUN mkdir -p /opt/eduid
ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

VOLUME ["/opt/eduid/etc", "/var/log/eduid"]

WORKDIR /
