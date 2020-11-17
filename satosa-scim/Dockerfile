FROM docker.sunet.se/eduid/satosa

MAINTAINER eduid-dev <eduid-dev@SEGATE.SUNET.SE>

COPY setup.sh /setup.sh
RUN /setup.sh
RUN /opt/satosa/bin/pip install -i https://pypi.sunet.se/simple/ eduid-scimapi
