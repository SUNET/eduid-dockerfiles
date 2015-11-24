FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

VOLUME ["/opt/eduid/nagios3/etc", "/opt/eduid/src", "/var/log/eduid", "/fcgiwrap", "/php5-fpm"]

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ADD start.sh /start.sh

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD www.conf /etc/php5/fpm/pool.d/www.conf


WORKDIR /

CMD ["bash", "/start.sh"]
