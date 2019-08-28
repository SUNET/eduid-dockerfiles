# Start by building the application.
FROM        debian:stable AS build
ENV         DEBIAN_FRONTEND noninteractive
RUN         apt-get update && apt-get install --no-install-recommends -y gnupg2
RUN         apt-get install -y apt-transport-https
COPY        influxdb.key /tmp
COPY        influxdb.list /etc/apt/sources.list.d/influxdb.list
RUN         apt-key add /tmp/influxdb.key
RUN         apt-get update && apt-get install -y influxdb
RUN         dpkg -L influxdb

RUN         ldd /usr/bin/influxd
RUN         ls -l /usr/bin/influx*

# Now copy it into our base image.
FROM gcr.io/distroless/base:debug

COPY --from=build /etc/influxdb /etc/influxdb
COPY --from=build /var/lib/influxdb /var/lib/influxdb
COPY --from=build /var/log/influxdb /var/log/influxdb
COPY --from=build /usr/lib/influxdb /usr/lib/influxdb
COPY --from=build /usr/share/man/man1/influx* /usr/share/man/man1/
COPY --from=build /usr/bin/influx* /usr/bin/

# This is the port to send data to (?)
EXPOSE      8086
# this is the RPC port for backups etc
EXPOSE      8088
VOLUME      ["/var/lib/influxdb"]
ENTRYPOINT  ["influxd", "-config", "/etc/influxdb/influxdb.conf"]
