FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive

RUN /bin/echo -e "deb http://se.archive.ubuntu.com/ubuntu trusty main restricted universe\ndeb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe\ndeb http://security.ubuntu.com/ubuntu trusty-security main restricted universe" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
      sed \
      git \
      build-essential \
      libpython-dev \
      python-pip \
      python-virtualenv && \
    apt-get clean

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/eduid
ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

VOLUME ["/opt/eduid/etc", "/var/log/eduid"]

WORKDIR /
