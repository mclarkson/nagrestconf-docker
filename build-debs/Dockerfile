FROM debian:jessie

# This is only for build so ENV is ok here
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    devscripts \
    debhelper \
    debootstrap

RUN mkdir -p /build && \
    cd /build && \
    git clone https://github.com/mclarkson/nagrestconf.git && \
    cd /build/nagrestconf/SOURCES/nagrestconf-1 && \
    ln -s debian.docker/ debian && \
    debuild -I -i -us -uc # 2

COPY pause.c /tmp/

RUN gcc -o /usr/sbin/pause /tmp/pause.c

ENTRYPOINT ["pause"]
