#
# mocked smtpd used in tests
#

FROM python:3-alpine

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

ADD setup.sh /opt/eduid/setup.sh
RUN /opt/eduid/setup.sh
ADD run-smtpdfix.py /run-smtpdfix.py

ENV SMTPD_HOST=0.0.0.0
ENV SMTPD_PORT=8025
ENV SMTPD_USE_STARTTLS=true
ENV SMTPD_USE_SSL=true
ENV SMTPD_ENFORCE_AUTH=true
ENV SMTPD_LOGIN_NAME=eduid_mail
ENV SMTPD_LOGIN_PASSWORD=secret

WORKDIR /

ENTRYPOINT ["/venv/bin/python", "-u", "/run-smtpdfix.py"]
