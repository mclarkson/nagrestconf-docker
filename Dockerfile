FROM ubuntu:xenial

RUN apt-get update -y && \
    apt-get install -y eatmydata

COPY buildfiles/*.deb /tmp/

ARG DEBIAN_FRONTEND
RUN eatmydata apt-get install -o APT::Install-Recommends="0" -y \
        apt-transport-https \
        gdebi-core \
        sudo \
        libapache2-mod-php7.0 && \
    gdebi -n /tmp/nagrestconf_1.174.7_all.deb && \
    dpkg -i /tmp/nagrestconf-backup-plugin_1.174.7_all.deb \
        /tmp/nagrestconf-hosts-bulktools-plugin_1.174.7_all.deb \
        /tmp/nagrestconf-services-bulktools-plugin_1.174.7_all.deb \
        /tmp/nagrestconf-services-plugin_1.174.7_all.deb # 1

RUN a2dismod mpm_event && \
    a2enmod mpm_prefork

COPY init.sh /sbin/init.sh

ENTRYPOINT ["/sbin/init.sh"]

RUN sed -i '/^start)/,/^stop/ {s/$HTTPD/exec $HTTPD/}' /usr/sbin/apache2ctl
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
RUN sed -i 's#http://127.0.0.1/rest#http://127.0.0.1:8080/rest#' /etc/nagrestconf/nagrestconf.ini
