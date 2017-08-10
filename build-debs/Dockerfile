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
    cp -a debian.docker/ debian.stretch && \
    cd debian.stretch && \
    sed -i 's/php5 [^,]*/php/;s/php5/php/;' control && \
    sed -i 's/php5/php7.0/' postinst && \
    cd .. && \
    ln -s debian.stretch/ debian && \
    debuild -I -i -us -uc

COPY pause.c /tmp/

RUN gcc -o /usr/sbin/pause /tmp/pause.c

ENTRYPOINT ["pause"]
