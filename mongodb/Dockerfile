# (NOTE: this container is only used in tests and in eduid-developer)
FROM debian:bullseye

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

# Install mongodb from mongodb.com
ADD mongodb-server-5.0.asc /etc/apt/trusted.gpg.d/mongodb-server-5.0.asc
RUN echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/5.0 main" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt-get update && apt-get install -y \
  vim \
  wget \
  mongodb-org \
  locales \
  python3-venv \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

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
