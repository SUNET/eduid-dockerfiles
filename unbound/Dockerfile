FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME [ "/etc/unbound" ]

EXPOSE 53
EXPOSE 8953

ADD start.sh /start.sh
ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh
ADD unbound.conf /etc/unbound/unbound.conf

WORKDIR /

CMD ["bash", "/start.sh"]
