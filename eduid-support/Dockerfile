FROM docker.sunet.se/eduid/eduid-webapp

ADD start.sh /start.sh

WORKDIR /

EXPOSE 8080

HEALTHCHECK --interval=10s CMD curl http://localhost:8080/status/healthy | grep -q STATUS_OK

CMD ["bash", "/start.sh"]
