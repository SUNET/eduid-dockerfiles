FROM	    docker.sunet.se/eduid/pythonenv:15.10
ADD         setup.sh /setup.sh
RUN	    /setup.sh
EXPOSE      6379
ADD         start.sh /start.sh
ENTRYPOINT  ["bash", "/start.sh"]
