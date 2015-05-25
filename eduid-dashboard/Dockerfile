FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/etc/eduid-dashboard", "/opt/eduid/run", "/opt/eduid/src"]

ADD stathat.py /root/stathat.py
ADD stathatasync.py /root/stathatasync.py
ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

EXPOSE 8080

CMD ["bash", "/start.sh"]
