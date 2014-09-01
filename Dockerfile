FROM ubuntu:latest
MAINTAINER Matej Kramny <matej@matej.me>

RUN apt-get update
RUN apt-get install -y apache2 php-pear php5-curl php5-mysql php5-odbc php5-imagick php5-mcrypt mysql-client curl git postfix libsasl2-modules rsyslog python-setuptools libapache2-mod-php5 php5-imap
RUN apt-get install -y imagemagick php5-imagick php5-gd
RUN pear install Mail Mail_Mime Net_SMTP Net_Socket Spreadsheet_Excel_Writer XML_RPC
RUN php5enmod mcrypt

RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

RUN a2enmod rewrite
RUN a2enmod php5

RUN rm -f /etc/apache2/sites-enabled/000-default.conf

ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/website.conf /etc/apache2/conf.d/website.conf
ADD conf/httpd.conf /etc/apache2/apache2.conf
ADD conf/php.ini /etc/php5/apache2/php.ini
ADD conf/postfix.cf /etc/postfix/main.cf
ADD conf/sasl_passwd /etc/postfix/sasl_passwd
ADD conf/rsyslog.conf /etc/rsyslog.conf
ADD conf/lamp.sh /etc/lamp.sh

RUN chmod +x /etc/lamp.sh

RUN chown -R root:root /etc/postfix
RUN chmod 600 /etc/postfix/sasl_passwd
RUN postmap /etc/postfix/sasl_passwd
# Maybe a fix for some errors..
RUN chmod o+rwx /var/spool/postfix/maildrop
RUN chmod o+x /var/spool/postfix/public

RUN apachectl configtest
RUN rm -rf /var/www

RUN service apache2 stop
RUN service postfix stop
RUN service rsyslog stop

EXPOSE 80
EXPOSE 443

CMD ["/etc/lamp.sh"]
