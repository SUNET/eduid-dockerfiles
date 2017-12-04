#
# Generic haproxy image for use in different places in eduID.
#

FROM debian:stable

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh

WORKDIR /

COPY cfgcheck.sh /cfgcheck.sh
COPY reload.sh /reload.sh

# This is the actual way that the image at https://hub.docker.com/_/haproxy/
# runs haproxy, but it's hidden behind a entrypoint script that modifies the arguments.
# The reason for running haproxy-systemd-wrapper is that it implements proper reloadability.
CMD ["/usr/sbin/haproxy-systemd-wrapper", "-p", "/run/haproxy.pid", "-f", "/etc/haproxy/haproxy.cfg"]
