# Start by building the application.
FROM debian:testing AS build
ARG TELEGRAF_VERSION

COPY telegraf_${TELEGRAF_VERSION}_amd64.deb /

RUN dpkg -i /telegraf_${TELEGRAF_VERSION}_amd64.deb
RUN dpkg -L telegraf

# Now copy it into our base image.
FROM gcr.io/distroless/base:debug
COPY --from=build /etc/telegraf /etc/telegraf
COPY --from=build /usr/lib/telegraf /usr/lib/telegraf
COPY --from=build /var/log/telegraf /var/log/telegraf
COPY --from=build /usr/bin/telegraf /usr/bin/telegraf

ENTRYPOINT ["/usr/bin/telegraf"]
