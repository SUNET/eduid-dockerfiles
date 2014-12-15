FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN apt-get update && apt-get install -y rabbitmq-server

ADD start.sh /start.sh

CMD ["bash", "/start.sh"]

VOLUME ["/etc/rabbitmq"]

EXPOSE 5672
