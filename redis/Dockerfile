FROM	    docker.sunet.se/eduid/pythonenv
ADD         setup.sh /setup.sh
RUN	    /setup.sh
EXPOSE      6379
ADD         start.sh /start.sh
ENTRYPOINT  ["bash", "/start.sh"]
