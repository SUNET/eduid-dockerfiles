FROM        debian:testing
ENV         DEBIAN_FRONTEND noninteractive
RUN         apt-get update && apt-get install -y graphite-carbon graphite-web supervisor gunicorn3 python-rrdtool
# for import from Munin
RUN	    apt-get install -y rename
# XXX maybe storage-schemas should not be part of the image?
#ADD         storage-schemas.conf /etc/carbon/storage-schemas.conf
ADD         supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD	    start.sh /start.sh
# This is the port to send data to (?)
EXPOSE      2003
# this is the port Grafana should talk to
EXPOSE	    8888
VOLUME      ["/var/lib/graphite"]
#CMD         ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
CMD	    ["/start.sh"]
