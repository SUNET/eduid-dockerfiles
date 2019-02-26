# pythonenv used to get environment for db-scripts
# (NOTE: this container is only used in tests and in eduid-developer)
FROM docker.sunet.se/eduid/python3env

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

# Install mongodb from mongodb.com
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
RUN echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list
RUN apt-get update && apt-get install -y \
  vim \
  wget \
  mongodb-org \
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
     </etc/mongod.conf >mongod.conf.new \
  && mv -f mongod.conf.new /etc/mongod.conf

# Define mountable directories.
VOLUME ["/data", "/var/log/mongodb", "/opt/eduid/etc", "/opt/eduid/db-scripts" ]

# Define working directory.
WORKDIR /data

ADD start.sh /start.sh

CMD ["bash", "/start.sh"]

EXPOSE 27017
EXPOSE 28017
