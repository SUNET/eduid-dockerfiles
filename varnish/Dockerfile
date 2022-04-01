FROM debian:testing

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

WORKDIR /

VOLUME [ "/var/lib/varnish" ]

# This is the start command used in sunet frontends
CMD ["varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-s", "malloc,100M", "-a", "0.0.0.0:1080"]
