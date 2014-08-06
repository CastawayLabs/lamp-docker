#!/bin/bash

cp /etc/resolv.conf /var/spool/postfix/etc/

if [ ! -z "$MANDRILL_PWD" ]
then
  echo "Using Mandrill Password. <= Written to /etc/postfix/sasl_passwd"

  echo "[smtp.mandrillapp.com]:587 $MANDRILL_PWD" > /etc/postfix/sasl_passwd
  chown -R postfix:postfix /etc/postfix
  chmod 600 /etc/postfix/sasl_passwd
  postmap /etc/postfix/sasl_passwd
fi

if [ ! -z "$RSYSLOG" ]
then
  echo "Adding RSYSLOGD configuration"
  
  echo "$RSYSLOG" >> /etc/rsyslog.conf
fi

/usr/bin/supervisord
