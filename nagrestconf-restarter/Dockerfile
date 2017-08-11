FROM ubuntu:xenial

RUN apt-get update -y

ARG DEBIAN_FRONTEND

COPY init.sh /sbin/init.sh

ENTRYPOINT ["/sbin/init.sh"]

