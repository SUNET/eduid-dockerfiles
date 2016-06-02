#
# Generic nginx imag for use in different places in eduID.
#

FROM debian:stable

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/var/log/nginx", "/etc/nginx/sites-enabled"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

CMD ["nginx"]
