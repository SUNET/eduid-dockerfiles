FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME [ "/etc/unbound" ]

EXPOSE 53
EXPOSE 8953

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

WORKDIR /

CMD ["/usr/sbin/unbound", "-dvvvc", "/etc/unbound/unbound.conf"]
