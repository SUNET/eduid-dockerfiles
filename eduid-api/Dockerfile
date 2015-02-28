FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/eduid-api/etc", "/opt/eduid/eduid-api/run", "/opt/eduid/src", "/var/log/eduid"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

EXPOSE 8511

CMD ["bash", "/start.sh"]
