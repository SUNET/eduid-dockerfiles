FROM debian:testing
ADD setup.sh /setup.sh
RUN /setup.sh

ENV PATH=/opt/frontend/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYTHONPATH=/opt/frontend

ENTRYPOINT ["bash"]
