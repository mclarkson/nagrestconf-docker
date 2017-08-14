# nagrestconf-docker

Run [nagrestconf](https://github.com/mclarkson/nagrestconf) in a docker container.

Two containers are created here, mclarkson/nagrestconf and mclarkson/nagrestconf-restarter.

Use with a compatible nagios container such as
[QuantumObject/docker-nagios](https://github.com/QuantumObject/docker-nagios)
or [JasonRivers/Docker-Nagios](https://github.com/JasonRivers/Docker-Nagios).

## Installation

## Running with QuantumObject/docker-nagios

Start the Nagios 4.x container
( See [QuantumObject/docker-nagios](https://github.com/QuantumObject/docker-nagios)):

```
docker run -d --name nagios -v /usr/local/nagios -p 25 -p 8080:80 quantumobject/docker-nagios
docker exec -it nagios /bin/bash
htpasswd /usr/local/nagios/etc/htpasswd.users nagiosadmin
exit
```

Start the nagrestconf container:

```
wget https://raw.githubusercontent.com/mclarkson/nagrestconf-docker/master/quantumobject_docker-nagios.env
docker run -d -p 8880:80 --name nagrestconf -v /tmp \
  --volumes-from nagios --env-file quantumobject_docker-nagios.env \
  mclarkson/nagrestconf
```

Set up the nagrestconf container:

```
docker exec -it nagrestconf /bin/bash
groupadd -g 999 nagios
useradd -u 999 -g 999 nagios -r
nagrestconf_install -n -q -o
slc_configure --folder=local
htpasswd -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin
exit
docker restart nagrestconf
```

Finally start the restart container (it restarts nagios using the `nagios.cmd` pipe):

```
docker run -d --name nagrestconf-restarter --volumes-from nagrestconf mclarkson/nagrestconf-restarter
```

With the above setup:

* Nagios is at http:/host:8080/nagios
* Nagrestconf is at http:/host:8880/nagrestconf

## Running with JasonRivers/Docker-Nagios

Start the Nagios 4.x container
(See [JasonRivers/Docker-Nagios](https://github.com/JasonRivers/Docker-Nagios)):

```
docker run -d --name nagios4 -p 8080:80 -v /opt/nagios jasonrivers/nagios:latest
```

Start the nagrestconf container:

```
wget https://raw.githubusercontent.com/mclarkson/nagrestconf-docker/master/jasonrivers_docker-nagios.env
docker run -d -p 8880:80 --name nagrestconf -v /tmp \
  --volumes-from nagios4 --env-file jasonrivers_docker-nagios.env \
  mclarkson/nagrestconf
```

Set up the nagrestconf container:

```
docker exec -it nagrestconf /bin/bash
echo "PATH=\$PATH:/opt/nagios/bin">>/etc/bash.bashrc
groupadd -g 1000 nagios
useradd -u 999 -g 1000 nagios -r
nagrestconf_install -n -q -o
slc_configure --folder=local
htpasswd -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin
exit
docker restart nagrestconf
```

Finally start the restart container (it restarts nagios using the `nagios.cmd` pipe):

```
docker run -d --name nagrestconf-restarter \
    -e NAGIOSCMD=/opt/nagios/var/rw/nagios.cmd \
    --volumes-from nagrestconf mclarkson/nagrestconf-restarter
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

