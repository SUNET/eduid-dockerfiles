FROM docker.sunet.se/eduid/eduid-webapp

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ADD setup.sh /opt/eduid/prepare.sh
RUN /opt/eduid/prepare.sh

WORKDIR /opt/eduid

EXPOSE 8080

ADD start.sh /start.sh

CMD ["bash", "/start.sh"]
