FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD www.conf /etc/php/7.0/fpm/pool.d/www.conf
ADD php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

WORKDIR /

VOLUME ["/opt/eduid/nagios3/etc", "/opt/eduid/src", "/var/log/eduid", "/var/run/nagios3"]

# php-fpm for .php scripts
EXPOSE 9000
# fastcgi for .cgi programs
EXPOSE 9001

CMD ["bash", "/start.sh"]
