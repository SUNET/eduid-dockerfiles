FROM docker.sunet.se/eduid/pythonenv

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
      opensc \
      libz-dev \
      mercurial \
      dnsutils \
      swig \
      softhsm2 \
    && apt-get clean

RUN rm -rf /var/lib/apt/lists/*

RUN /opt/eduid/bin/pip install --upgrade git+https://github.com/LudovicRousseau/PyKCS11#egg=pykcs11
RUN /opt/eduid/bin/pip install --upgrade git+https://github.com/IdentityPython/pyeleven#egg=pyeleven
RUN /opt/eduid/bin/pip install gunicorn flask

WORKDIR /

COPY start.sh /start.sh
RUN chmod 775 /start.sh

CMD ["bash", "/start.sh"]
