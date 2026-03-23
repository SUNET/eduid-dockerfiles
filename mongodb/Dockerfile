# (NOTE: this container is only used in tests and in eduid-developer)
FROM debian:stable

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

# Install mongodb from mongodb.com
# Mongodb 6.0 needs libssl1.1 which is not available in Debian stable
ADD libssl1.1_1.1.1w-0+deb11u2_amd64.deb /tmp/libssl1.1_1.1.1w-0+deb11u2_amd64.deb
RUN dpkg -i /tmp/libssl1.1_1.1.1w-0+deb11u2_amd64.deb
RUN rm /tmp/libssl1.1_1.1.1w-0+deb11u2_amd64.deb
# end libssl1.1 hack
RUN apt-get update && apt-get install -y \
  vim \
  wget \
  locales \
  python3-venv \
  gnupg

ADD mongodb-server-6.0.asc /etc/apt/trusted.gpg.d/mongodb-server-6.0.asc
RUN echo "deb [ signed-by=/etc/apt/trusted.gpg.d/mongodb-server-6.0.asc ] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
# MongoDB 6.0 key uses SHA1 binding signatures which Debian trixie's sqv rejects; fall back to gpgv
RUN echo 'Apt::Key::gpgvcommand "gpgv";' > /etc/apt/apt.conf.d/99gpgv-compat
RUN apt-get update && apt-get install -y \
  mongodb-org \
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
