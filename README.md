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

docker run -d -p 8880:8080 --name nagrestconf -v /tmp \
  --volumes-from nagios --env-file quantumobject_docker-nagios.env \
  mclarkson/nagrestconf
```

Finally start the restart container:

```
docker run -d --name nagrestconf-restarter --volumes-from nagrestconf mclarkson/nagrestconf-restarter
```

With the above setup:

* Nagios is at http://localhost:8080/nagios
* Nagrestconf is at http://localhost:8880/nagrestconf<br>
  Default credentials: nagrestconfadmin / admin

To change the nagrestconf default password:

```
docker exec -it nagrestconf /bin/bash
htpasswd -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin
exit
```

## Running with JasonRivers/Docker-Nagios

Start the Nagios 4.x container
(See [JasonRivers/Docker-Nagios](https://github.com/JasonRivers/Docker-Nagios)):

```
docker run -d --name nagios4 -p 8080:80 -v /opt/nagios jasonrivers/nagios:latest
```

Start the nagrestconf container:

```
wget https://raw.githubusercontent.com/mclarkson/nagrestconf-docker/master/jasonrivers_docker-nagios.env

docker run -d -p 8880:8080 --name nagrestconf -v /tmp \
  --volumes-from nagios4 --env-file jasonrivers_docker-nagios.env \
  mclarkson/nagrestconf
```

Finally start the restart container:

```
docker run -d --name nagrestconf-restarter \
    -e NAGIOSCMD=/opt/nagios/var/rw/nagios.cmd \
    --volumes-from nagrestconf mclarkson/nagrestconf-restarter
```

With the above setup:

* Nagios is at http://localhost:8080/nagios<br>
  Default credentials: nagiosadmin / nagios
* Nagrestconf is at http://localhost:8880/nagrestconf<br>
  Default credentials: nagrestconfadmin / admin

To change the nagrestconf default password:

```
docker exec -it nagrestconf /bin/bash
htpasswd -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin
exit
```

## Running with Kubernetes

Create the pod:
```
wget https://raw.githubusercontent.com/mclarkson/nagrestconf-docker/master/kubernetes/nagios-nagrestconf-allinone.yml

kubectl create -f nagios-nagrestconf-allinone.yml
```

Get a console on the nagios container:
```
name=$(kubectl get pods -l app=nagrestconf -o jsonpath="{.items[0].metadata.name}")

kubectl exec -ti $name -c nagios bash
```

Set the password:
```
htpasswd /usr/local/nagios/etc/htpasswd.users nagiosadmin
exit
```

Use port-forward to test:
```
kubectl port-forward $name 8080:80 8880:8080
```

With the above setup:

* Nagios is at http://localhost:8080/nagios
* Nagrestconf is at http://localhost:8880/nagrestconf<br>
  Default credentials: nagrestconfadmin / admin

Take a look in the `kubernetes/` directory to see service and ingress yaml examples.

## Running with Helm

## Environment Variables

```
/etc/nagrestconf/csv2nag.conf    default value
-----------------------------    ------------------------
CSV2NAG_DCC                      0
CSV2NAG_REMOTE_EXECUTOR          check_any
CSV2NAG_FRESHNESS_CHECK_COMMAND  no-checks-received

/etc/nagrestconf/nagctl.conf
----------------------------
NAGCTL_NAG_DIR                   /etc/nagios3
NAGCTL_NAG_OBJ_DIR               \$NAG_DIR/objects
NAGCTL_NAG_CONFIG                \$NAG_DIR/nagios.cfg
NAGCTL_COMMANDFILE               /var/lib/nagios3/rw
NAGCTL_NAGIOSBIN                 /usr/sbin/nagios3
NAGCTL_CSV2NAG                   /usr/bin/csv2nag
NAGCTL_WWWUSER                   www-data

/etc/nagrestconf/nagrestconf.ini
--------------------------------
NAGRESTCONF_INI_RESTURL          http://127.0.0.1:8080/rest
NAGRESTCONF_INI_FOLDER           local
NAGRESTCONF_INI_RESTUSER         user
NAGRESTCONF_INI_RESTPASS         pass

/etc/nagrestconf/restart_nagios.conf (unused)
---------------------------------------------
RESTART_NAGIOS_CONF_NAG_INITD    nagios3 (unused)
```

## Build

To build, recompiling nagrestconf from github mclarkson/nagrestconf and remaking
nagrestconf and nagrestconf-restarter images, use:

```
bash build.sh
```

