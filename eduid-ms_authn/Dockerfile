FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/etc", "/opt/eduid/src", "/var/log/eduid"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

WORKDIR /opt/eduid

EXPOSE 8080

ADD start.sh /start.sh

CMD ["bash", "/start.sh"]
