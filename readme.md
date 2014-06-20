
LAMP on Docker
==============

How to use
----------

This is not in the docker registry yet..

1. `docker build -t CastawayLabs/lamp-docker git://github.com/CastawayLabs/lamp-docker.git`
2. Make directories for your website files. We use the following setup:
 - `mkdir -p /home/websites/domain.com`
 - `chmod 750 /home/websites`
 - `chown root:root /home/websites`
 - Nginx routing host:80 to a port opened by docker (see below)
3. Run the docker image
 - If you have a mysql instance running, and want to link it to the container, see section below.
 - `docker run -d --name "domain.com" -p 8080:80 -v /home/websites/domain.com:/var/www CastawayLabs/lamp-docker`

Linking MySQL
-------------

Run a mysql instance, make sure to name it 'mysql' or similar.

```
docker run -d --name "domain.com" \
	-p 8080:80 \
	-v /home/websites/domain.com:/var/www \
	--link mysql:db \
	-e "DB_USER={MYSQL_USER}" \
	-e "DB_PASS={MYSQL_PASSWORD}" \
	-e "DB_NAME={MYSQL_DB_NAME}" \
	CastawayLabs/lamp-docker
```

In your PHP script, access those variables using:

```
$db_name = getenv('DB_NAME');
$db_pass = getenv('DB_PASS');
$db_user = getenv('DB_USER');
$db_host = getenv('DB_PORT_3306_TCP_ADDR');
```

Tips and tricks
---------------

- Export log files from docker: `docker cp domain.com:/var/log domain.com_logs`
