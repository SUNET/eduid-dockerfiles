FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN ln -s /usr/lib/libxmlsec1-openssl.so.1 /usr/lib/libxmlsec1-openssl.so

VOLUME ["/opt/eduid/etc"]

RUN echo "#!/bin/sh" > /start.sh \
  && echo "" >> /start.sh \
  && echo "service eduid_msg start" >> /start.sh \
  && echo "tail -F /var/log/upstart/eduid_msg.log" >> /start.sh

WORKDIR /

ENV C_FORCE_ROOT 1

CMD ["bash", "/start.sh"]
