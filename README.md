# nagrestconf-docker

Run [nagrestconf](https://github.com/mclarkson/nagrestconf) in a docker container.

Two containers are created here, mclarkson/nagrestconf and mclarkson/nagrestconf-restarter.

Use a compatible nagios container such as [QuantumObject/docker-nagios](https://github.com/QuantumObject/docker-nagios).

## Installation

Run a compatible nagios docker container, for instance [QuantumObject/docker-nagios](https://github.com/QuantumObject/docker-nagios):

```
docker run -d --name nagios -v /usr/local/nagios -p 25 -p 8080:80 quantumobject/docker-nagios
docker exec -it nagios /bin/bash
htpasswd /usr/local/nagios/etc/htpasswd.users nagiosadmin
exit
```

Run the nagrestconf container:

```
docker run -d -p 8880:80 --name nagrestconf -v /tmp \
  --volumes-from nagios --env-file quantumobject_docker-nagios.env \
  mclarkson/nagrestconf
```

Set up the nagrestconf container fully:

```
docker exec -it nagrestconf /bin/bash
groupadd -g 999 nagios
useradd -u 999 -g 999 nagios -r
nagrestconf_install -n -q -o
slc_configure --folder=local
htpasswd -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin
docker restart nagrestconf
exit
```

Finally start the restart container:

```
docker run -d --name nagrestconf-restarter --volumes-from nagrestconf mclarkson/nagrestconf-restarter
```

With the above setup:

* Nagios is at http:/host:8080/nagios
* Nagrestconf is at http:/host:8880/nagrestconf

## Build

To build, recompiling nagrestconf from github mclarkson/nagrestconf and remaking
nagrestconf and nagrestconf-restarter images, use:

```
bash build.sh
```

