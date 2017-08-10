FROM ubuntu:xenial

RUN apt-get update -y && \
    apt-get install -y eatmydata

COPY buildfiles/*.deb /tmp/

ARG DEBIAN_FRONTEND
RUN eatmydata apt-get install -o APT::Install-Recommends="0" -y apt-transport-https \
        gdebi-core && \
    gdebi -n /tmp/nagrestconf_1.174.7_all.deb && \
    dpkg -i /tmp/nagrestconf-backup-plugin_1.174.7_all.deb \
        /tmp/nagrestconf-hosts-bulktools-plugin_1.174.7_all.deb \
        /tmp/nagrestconf-services-bulktools-plugin_1.174.7_all.deb \
        /tmp/nagrestconf-services-plugin_1.174.7_all.deb

#RUN nagrestconf_install -a && \
#    slc_configure --folder=local && \
#    sed -i 's/check_external_commands=0/check_external_commands=1/g' /etc/nagios3/nagios.cfg \
#    sed -i 's/enable_embedded_perl=1/enable_embedded_perl=0/g' /etc/nagios3/nagios.cfg \

