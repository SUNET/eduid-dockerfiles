FROM ubuntu:15.10

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive

RUN /bin/echo -e "deb http://se.archive.ubuntu.com/ubuntu wily main restricted universe\ndeb http://archive.ubuntu.com/ubuntu wily-updates main restricted universe\ndeb http://security.ubuntu.com/ubuntu wily-security main restricted universe" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
      sed \
      git \
      build-essential \
      libpython-dev \
      python-pip \
      python-virtualenv \
      iputils-ping \
    && apt-get clean

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/eduid
ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

VOLUME ["/opt/eduid/etc", "/var/log/eduid"]

WORKDIR /
