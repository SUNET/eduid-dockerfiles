FROM debian:stable

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive

RUN /bin/sed -i s/deb.debian.org/ftp.se.debian.org/g /etc/apt/sources.list

RUN apt-get update && \
    apt-get -y dist-upgrade && \
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
