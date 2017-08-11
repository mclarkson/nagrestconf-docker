# nagrestconf-docker

Run [nagrestconf](https://github.com/mclarkson/nagrestconf) in a docker container.

```
docker run -d --name nagios -v /usr/local/nagios/etc -p 25 -p 80 quantumobject/docker-nagios
docker exec -it nagios /bin/bash
htpasswd /usr/local/nagios/etc/htpasswd.users nagiosadmin
exit
```
```
docker run --name nagrestconf --volumes-from nagios -d -p 8080:80 nagrestconf
docker exec -it nagrestconf /bin/bash
htpasswd -c /etc/nagrestconf/nagrestconf.users nagrestconfadmin
exit
```
