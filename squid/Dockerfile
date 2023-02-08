FROM debian:stable

RUN apt-get -q update && \
    apt-get -y dist-upgrade && \
    apt-get -qy install squid && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/var/log/squid", "/etc/squid"]

EXPOSE 3128
EXPOSE 8080

CMD [ "squid", "-N", "-f", "/etc/squid/squid.conf" ]
