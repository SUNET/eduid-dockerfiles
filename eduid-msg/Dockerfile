FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN ln -s /usr/lib/libxmlsec1-openssl.so.1 /usr/lib/libxmlsec1-openssl.so

VOLUME ["/opt/eduid/etc"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

WORKDIR /

ENV C_FORCE_ROOT 1

CMD ["bash", "/start.sh"]
