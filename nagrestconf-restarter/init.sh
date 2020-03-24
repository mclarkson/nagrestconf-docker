#!/bin/bash

NAGIOSCMD=${NAGIOSCMD:-"/usr/local/nagios/var/rw/nagios.cmd"}

while true; do
    [[ -e /tmp/nagios_restart_request ]] && {
        rm -f /tmp/nagios_restart_request
        echo "[`date +%s`] RESTART_PROGRAM" >$NAGIOSCMD
    }
    sleep 60
done
