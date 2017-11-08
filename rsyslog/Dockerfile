FROM debian
ADD setup.sh /setup.sh
RUN /setup.sh
EXPOSE 514
ADD start.sh /start.sh
ADD rsyslog.conf /etc/rsyslog.conf
CMD ["bash", "/start.sh"]
