FROM debian

RUN apt-get -q update && \
    apt-get -y dist-upgrade && \
    apt-get -qy install squid3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME ["/var/log/squid", "/etc/squid"]

EXPOSE 3128
EXPOSE 8080

CMD [ "squid3", "-N", "-f", "/etc/squid/squid.conf" ]
