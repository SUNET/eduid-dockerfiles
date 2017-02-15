FROM docker.sunet.se/eduid/pythonenv

ADD start.sh /start.sh

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

WORKDIR /

ENTRYPOINT ["/bin/bash", "-c", "/start.sh ${*}", "--"]
