#!/bin/bash

# CSV2NAG_DCC
# CSV2NAG_REMOTE_EXECUTOR
# CSV2NAG_FRESHNESS_CHECK_COMMAND
# NAGCTL_NAG_DIR
# NAGCTL_NAG_OBJ_DIR
# NAGCTL_NAG_CONFIG
# NAGCTL_COMMANDFILE
# NAGCTL_NAGIOSBIN
# NAGCTL_CSV2NAG
# NAGCTL_WWWUSER
# NAGRESTCONF_INI_RESTURL
# NAGRESTCONF_INI_FOLDER
# NAGRESTCONF_INI_RESTUSER
# NAGRESTCONF_INI_RESTPASS
# RESTART_NAGIOS_CONF_NAG_INITD

# write csv2nag.conf

cat >/etc/nagrestconf/csv2nag.conf <<EnD
# Set DCC=1 if this is a data centre collector
DCC=${CSV2NAG_DCC:-0}

# pnp4nagios helper.
#remote_executor="check_nrpe"
REMOTE_EXECUTOR=${CSV2NAG_REMOTE_EXECUTOR:-"check_any"}

# The command used to check freshness (on DCC)
FRESHNESS_CHECK_COMMAND=${CSV2NAG_FRESHNESS_CHECK_COMMAND:-"no-checks-received"}
EnD

# write nagctl.conf

cat >/etc/nagrestconf/nagctl.conf <<EnD
# Nagios 'etc' directory.
NAG_DIR=${NAGCTL_NAG_DIR:-"/etc/nagios3"}

# Where the objects directory is. It must be created manually.
NAG_OBJ_DIR=${NAGCTL_NAG_OBJ_DIR:-"\$NAG_DIR/objects"}

# Where nagios.cfg file is.
NAG_CONFIG=${NAGCTL_NAG_CONFIG:-"\$NAG_DIR/nagios.cfg"}

# Where some livestatus files are
#LIVESTATUSCOMMANDFILE='/var/log/nagios/rw/live'
#LIVESTATUSUNIXCAT='/usr/bin/unixcat'

# Where the nagios.cmd file is.
COMMANDFILE=${NAGCTL_COMMANDFILE:-"/var/lib/nagios3/rw"}

# Where nagios is.
NAGIOSBIN=${NAGCTL_NAGIOSBIN:-"/usr/sbin/nagios3"}

# Where csv2nag is.
CSV2NAG=${NAGCTL_CSV2NAG:-"/usr/bin/csv2nag"}

# The user apache runs as.
WWWUSER=${NAGCTL_WWWUSER:-"www-data"}
EnD

# write nagrestconf.ini

cat >/etc/nagrestconf/nagrestconf.ini <<EnD
; Configuration file for nagrestconf

;resturl  = "https://127.0.0.1/rest"
resturl  = ${NAGRESTCONF_INI_RESTURL:-"http://127.0.0.1:8080/rest"}
folder[] = ${NAGRESTCONF_INI_FOLDER:-"local"}
restuser = ${NAGRESTCONF_INI_RESTUSER:-"user"}
restpass = ${NAGRESTCONF_INI_RESTPASS:-"pass"}
; Use a pasword-less ssl key and certificate
;sslkey = "/path/to/key"
;sslcert = "/path/to/cert"
EnD

# write restart_nagios.conf

cat >/etc/nagrestconf/restart_nagios.conf <<EnD
# Config file for restart_nagios script
NAG_INITD=${RESTART_NAGIOS_CONF_NAG_INITD:-"nagios3"}

# Address of the collector nagios
# Leave unset if there is no dcc.
#dcc="10.0.0.0"
EnD

export APACHE_ARGUMENTS="-DFOREGROUND"

# Edit sudoers and users
uid=$(stat $(find $NAGCTL_NAG_DIR ! -uid 0 | head -1) --format %u)
gid=$(stat $(find $NAGCTL_NAG_DIR ! -uid 0 | head -1) --format %g)
groupadd -g $gid nagios
useradd -u $uid -g $gid nagios -r
nagrestconf_install -q -o

# One-time only
[[ ! -e NAGCTL_NAG_DIR/repos ]] && {
    nagpath=$(dirname $NAGCTL_NAGIOSBIN)
    echo "PATH=\$PATH:$nagpath">>/etc/bash.bashrc
    nagrestconf_install -n
    slc_configure --folder=local
    htpasswd -b -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin admin
}

exec apache2ctl start
