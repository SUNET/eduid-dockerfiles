FROM debian:jessie

ARG STATSD_VERSION

RUN apt-get update && \
    apt-get -y --no-install-recommends install nodejs git && \
    apt-get clean

#RUN git clone -b $STATSD_VERSION https://github.com/etsy/statsd/ /statsd
ADD statsd /statsd

EXPOSE 8125/udp 8126

ADD ./start.sh /start.sh

CMD ["bash", "/start.sh"]
