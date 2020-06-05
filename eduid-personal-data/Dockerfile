FROM docker.sunet.se/eduid/eduid-webapp

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/etc", "/opt/eduid/run", "/opt/eduid/src", "/var/log"]

WORKDIR /opt/eduid

EXPOSE 8080

ADD start.sh /start.sh

HEALTHCHECK --interval=41s CMD curl http://localhost:8080/status/healthy | grep -q STATUS_OK

CMD ["bash", "/start.sh"]
