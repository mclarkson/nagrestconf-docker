# nagrestconf-docker

Run [nagrestconf](https://github.com/mclarkson/nagrestconf) in a docker container.

## Installation

Run a nagios docker container, for instance:

```
docker run -d --name nagios -v /usr/local/nagios -p 25 -p 80 quantumobject/docker-nagios
docker exec -it nagios /bin/bash
htpasswd /usr/local/nagios/etc/htpasswd.users nagiosadmin
exit
```

Run the nagrestconf container:

```
docker run -d -p 8880:80 \
  --name nagrestconf \
  --volumes-from nagios \
  --env-file quantumobject_docker-nagios.env \
  nagrestconf
```

Set the nagrestconf password

```
docker exec -it nagrestconf /bin/bash
groupadd -g 999 nagios
useradd -u 999 -g 999 nagios -r
nagrestconf_install -n -q -o
slc_configure --folder=local
htpasswd -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin
exit
```
