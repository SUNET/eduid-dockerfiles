FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN apt-get update && apt-get install -y rabbitmq-server

RUN echo "#!/bin/sh" > start.sh \
  && echo "" >> start.sh \
  && echo "service rabbitmq-server start" >> start.sh \
  && echo "rabbitmqctl add_user eduid eduid" >> start.sh \
  && echo "rabbitmqctl add_vhost eduid_msg" >> start.sh \
  && echo "rabbitmqctl set_permissions -p eduid_msg eduid \".*\" \".*\" \".*\"" >> start.sh \
  && echo "rabbitmqctl add_vhost eduid_vhost" >> start.sh \
  && echo "rabbitmqctl set_permissions -p eduid_vhost eduid \".*\" \".*\" \".*\"" >> start.sh \
  && echo "tail -f /var/log/rabbitmq/*" >> start.sh

CMD ["bash", "/start.sh"]

VOLUME ["/etc/rabbitmq"]

EXPOSE 5672
