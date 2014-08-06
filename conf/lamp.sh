#!/bin/bash

/etc/init.d/rsyslog start
/etc/init.d/syslog-ng start
/usr/sbin/postfix -c /etc/postfix start
source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND
