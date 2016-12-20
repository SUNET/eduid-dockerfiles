FROM ubuntu:16.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/etc/munin", "/var/run/munin" ]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /

# fastcgi for munin-cgi-html
EXPOSE 9000
# fastcgi for munin-cgi-graph
EXPOSE 9001

CMD ["bash", "/start.sh"]
