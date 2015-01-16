FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN apt-get update && apt-get install -y rabbitmq-server

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

CMD ["bash", "/start.sh"]

VOLUME ["/etc/rabbitmq", "/var/log/rabbitmq"]

EXPOSE 5672
EXPOSE 15672
