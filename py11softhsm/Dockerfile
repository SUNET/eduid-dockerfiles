FROM debian:stable as build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
      build-essential \
      dnsutils \
      git \
      libpython3-dev \
      libz-dev \
      python3-cffi \
      python3-venv \
      swig \
    && apt-get clean

RUN rm -rf /var/lib/apt/lists/*


RUN mkdir -p /opt
RUN python3 -mvenv /opt/eduid

RUN /opt/eduid/bin/pip install --upgrade wheel
RUN /opt/eduid/bin/pip install --upgrade git+https://github.com/LudovicRousseau/PyKCS11#egg=pykcs11
RUN /opt/eduid/bin/pip install --upgrade git+https://github.com/IdentityPython/pyeleven#egg=pyeleven
RUN /opt/eduid/bin/pip install gunicorn flask


FROM debian:stable

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive

# Add user/group before installing any packages to get consistent uid/gid
RUN addgroup --system eduid && adduser --system --shell /bin/false --ingroup eduid eduid

#
# Install tools that are helpful when troubleshooting, and some things needed in runtime.
#
# ssl-cert is used for the default healthcheck (in /healthcheck.sh)
#
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y \
      bind9-host \
      curl \
      iputils-ping \
      net-tools \
      netcat-openbsd \
      opensc \
      procps \
      python3-minimal \
      ssl-cert \
      softhsm2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/eduid && chown eduid: /var/log/eduid && chmod 770 /var/log/eduid

COPY --from=build /opt/eduid /opt/eduid

WORKDIR /

COPY start.sh /start.sh
COPY import-key.sh /import-key.sh
COPY healthcheck.sh /healthcheck.sh
COPY keys.txt /keys.txt
RUN chmod 775 /start.sh /import-key.sh /healthcheck.sh

# This is where SoftHSM2 will store its data (including the imported keys)
VOLUME /var/lib/softhsm

HEALTHCHECK --interval=27s CMD /healthcheck.sh

CMD ["bash", "/start.sh"]
