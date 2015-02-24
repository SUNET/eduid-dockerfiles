FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

#VOLUME ["/opt/eduid/etc/eduid_mm_service"]

#ADD eduid-mm-service-0.1-SNAPSHOT.jar /opt/eduid/eduid-mm-service-0.1-SNAPSHOT.jar

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

ENV C_FORCE_ROOT 1

EXPOSE 8080

CMD ["bash", "/start.sh"]
