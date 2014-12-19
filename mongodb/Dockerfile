# pythonenv used to get environment for db-scripts
FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN apt-get update && apt-get install -y \
  vim \
  wget \
  mongodb \
  locales

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

RUN sed -e "s/^\(bind_ip =\).\+$/\1 0.0.0.0/" \
        -e "s/^\(dbpath =\).\+$/\1 \/data/" \
        -e "s/^\(logpath =\).\+$/\1 \/data\/mongod.log/" \
        -e "s/^\(oplogSize =\).\+$/\1 10/" \
     </etc/mongodb.conf >mongodb.conf.new \
  && mv -f mongodb.conf.new /etc/mongodb.conf

# Define mountable directories.
VOLUME ["/data", "/var/log/mongodb", "/opt/eduid/etc", "/opt/eduid/db-scripts" ]

# Define working directory.
WORKDIR /data

ADD start.sh /start.sh

CMD ["bash", "/start.sh"]

EXPOSE 27017
EXPOSE 28017
