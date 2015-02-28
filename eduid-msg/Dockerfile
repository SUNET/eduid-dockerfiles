FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/eduid-msg/etc", "/opt/eduid/eduid-msg/run", "/var/log/eduid"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

# C_FORCE_ROOT makes celery task run as root
#ENV C_FORCE_ROOT 1

CMD ["bash", "/start.sh"]
