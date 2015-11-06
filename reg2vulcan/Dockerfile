FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/eduid-idp/etc", "/opt/eduid/src", "/var/log/eduid"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

ADD reg2vulcan /opt/eduid/bin/reg2vulcan

WORKDIR /

CMD ["bash", "/start.sh"]
