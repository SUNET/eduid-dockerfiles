FROM docker.sunet.se/eduid/eduid-webapp

ADD start.sh /start.sh
ADD setup.sh /setup.sh

RUN /setup.sh

WORKDIR /

EXPOSE 8080

CMD ["bash", "/start.sh"]
