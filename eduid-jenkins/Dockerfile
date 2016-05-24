FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive

RUN /bin/echo -e "deb http://se.archive.ubuntu.com/ubuntu wily main restricted universe\ndeb http://archive.ubuntu.com/ubuntu wily-updates main restricted universe\ndeb http://security.ubuntu.com/ubuntu wily-security main restricted universe" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y \
      mongodb \
      redis-server \
      python-dev \
      libxml2-dev \
      libxslt1-dev \
      zlib1g-dev \
      sloccount \
      libffi-dev \
      libssl-dev \
      xmlsec1 \
      libtiff5-dev \
      libjpeg8-dev \
      zlib1g-dev \
      libfreetype6-dev \
      liblcms2-dev \
      libwebp-dev \
      tcl8.6-dev \
      tk8.6-dev \
      python-tk \
      libnettle6 \
    && apt-get clean

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/eduid
ADD setup.sh /opt/eduid/setup.sh
ADD build.sh /opt/eduid/build.sh
RUN /opt/eduid/setup.sh

WORKDIR /
