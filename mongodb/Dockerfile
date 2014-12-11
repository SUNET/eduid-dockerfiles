FROM ubuntu:14.04

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

RUN apt-get update && apt-get install -y \
  vim \
  wget \
  mongodb \
  locales

#RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && \
#    locale-gen C.UTF-8 && \
#    /usr/sbin/update-locale LANG=C.UTF-8

ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

RUN sed -e "s/^\(bind_ip =\).\+$/\1 0.0.0.0/" \
        -e "s/^\(dbpath =\).\+$/\1 \/data/" \
        -e "s/^\(logpath =\).\+$/\1 \/data\/mongod.log/" \
        -e "s/^\(oplogSize =\).\+$/\1 10/" \
     </etc/mongodb.conf >mongodb.conf.new \
  && mv -f mongodb.conf.new /etc/mongodb.conf \
  && mkdir -p /data/db

# Define mountable directories.
VOLUME ["/data", "/var/log/mongodb", "/opt/eduid/etc" ]

# Define working directory.
WORKDIR /data

CMD ["/usr/bin/mongod", "--config", "/opt/eduid/etc/mongodb.conf"]

EXPOSE 27017
EXPOSE 28017
