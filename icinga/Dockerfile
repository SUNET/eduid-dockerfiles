FROM docker.sunet.se/eduid/python3env

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD www.conf /etc/php/7.3/fpm/pool.d/www.conf
ADD php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
# Add SUNET infra cert
ADD infra.crt /usr/local/share/ca-certificates/
RUN /usr/sbin/update-ca-certificates

WORKDIR /

VOLUME ["/opt/eduid/icinga/etc", "/opt/eduid/src", "/var/log/eduid", "/var/run/icinga"]

# php-fpm for .php scripts
EXPOSE 9000
# fastcgi for .cgi programs
EXPOSE 9001

CMD ["bash", "/start.sh"]
