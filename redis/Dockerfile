#
# Redis Dockerfile
#
# initial copy from https://github.com/dockerfile/redis
#

FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN apt-get update && apt-get install -y \
  redis-server \
  locales

RUN mkdir -p /opt/eduid

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Define mountable directories.
VOLUME ["/data", "/var/log/redis", "/opt/eduid/etc"]

# Define working directory.
WORKDIR /data

# Define default command.
ADD start.sh /start.sh

CMD ["bash", "/start.sh"]

# Expose ports.
EXPOSE 6379
