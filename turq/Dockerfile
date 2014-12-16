FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh
ADD run_turq /run_turq

WORKDIR /

EXPOSE 13085

CMD ["bash", "/start.sh"]
