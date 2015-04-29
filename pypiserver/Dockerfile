FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/pypiserver/etc", "/opt/eduid/pypiserver/packages", "/var/log/pypiserver"]

ADD setup.sh /opt/eduid/setup.sh

RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

EXPOSE 8080

CMD ["bash", "/start.sh"]
