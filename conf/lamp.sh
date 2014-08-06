#!/bin/bash

if env | grep -q ^MANDRILL_PWD=
then
  echo "Using Mandrill Password. <= Written to /etc/postfix/sasl_passwd"
  
  echo "[smtp.mandrillapp.com]:587 $MANDRILL_PWD" > /etc/postfix/sasl_passwd
  chown -R postfix:postfix /etc/postfix
  chmod 600 /etc/postfix/sasl_passwd
  postmap /etc/postfix/sasl_passwd
fi

/usr/bin/supervisord
