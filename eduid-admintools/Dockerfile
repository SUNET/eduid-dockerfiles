FROM docker.sunet.se/eduid/webapp

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

ENTRYPOINT ["bash", "/start.sh"]
