#
# Generic nginx imag for use in different places in eduID.
#

FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/var/log/nginx"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

ADD html.conf /etc/nginx/sites-enabled/html.conf

WORKDIR /

CMD ["nginx"]
