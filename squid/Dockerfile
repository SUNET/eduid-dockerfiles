FROM ubuntu:14.04

RUN apt-get -q update && \
    apt-get -qy install squid3

#ADD eduid_*_dstdomain.acl /etc/squid3/
#ADD squid.conf /etc/squid3/squid.conf

VOLUME ["/var/log/squid3", "/etc/squid3"]

EXPOSE 3128
EXPOSE 8080

CMD [ "squid3", "-N" ]
