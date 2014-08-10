
LAMP on Docker
==============

How to use
----------

Available in the docker registry under `castawaylabs/lamp-docker`

Manual build:

1. `docker build -t CastawayLabs/lamp-docker git://github.com/CastawayLabs/lamp-docker.git`

Usage:

1. Make directories for your website files. We use the following setup:
 - `mkdir -p /home/websites/domain.com`
 - `chmod 750 /home/websites`
 - `chown root:root /home/websites`
 - Nginx routing host:80 to a port opened by docker (see below)
2. Run the docker image
 - If you have a mysql instance running, and want to link it to the container, see section below.
 - `docker run -d --name "domain.com" --hostname "domain.com" -p 8080:80 -v /home/websites/domain.com:/var/www CastawayLabs/lamp-docker`
3. There is no step 3. See below for additional configuration

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

Sending Email
-------------

This image is configured to relay mail through mandrill. _(contribute to add other mail relays)._

Add the following environment variables when starting the image:
- `MANDRILL_PWD=you@domain.com:myAPIPasswordGeneratedFromMandrillapp.com`

Logging
-------

An interesting topic with docker, we've solved it by sending the log files to [papertrail](papertrailapp.com). Setting a hostname will ensure you know which log container to look at when required, and not having to dig around with `docker cp` etc.

Set this environment variable to enable logging:
- `RSYSLOG=*.* @logs2.papertrailapp.com:12345`

Tips and tricks
---------------

- Export log files from docker: `docker cp domain.com:/var/log domain.com_logs`
- Look for messages at boot for diagnostics. It will say something about mandrill if its enabled, and something about RSYSLOG when you enable logging.
