#!/bin/bash

if ![ -z "$MANDRILL_PWD" ]; then
  echo "[smtp.mandrillapp.com]:587 $MANDRILL_PWD" > /etc/postfix/sasl_passwd
  chown -R postfix:postfix /etc/postfix
  chmod 600 /etc/postfix/sasl_passwd
  postmap /etc/postfix/sasl_passwd
fi

/etc/init.d/rsyslog start
/etc/init.d/syslog-ng start
/usr/sbin/postfix -c /etc/postfix start
source /etc/apache2/envvars && exec /usr/sbin/apache2 -D FOREGROUND
