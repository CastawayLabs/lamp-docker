FROM phusion/baseimage
MAINTAINER Matej Kramny <matej@matej.me>

RUN apt-get update
RUN apt-get install -y apache2 php-pear php5-curl php5-mysql php5-odbc php5-imagick php5-mcrypt mysql-client curl git postfix libsasl2-modules rsyslog python-setuptools libapache2-mod-php5
RUN apt-get install -y syslog-ng
RUN apt-get install -y imagemagick php5-imagick
RUN pear install Mail Mail_Mime Net_SMTP Net_Socket Spreadsheet_Excel_Writer XML_RPC

RUN a2enmod rewrite
RUN a2enmod php5

RUN rm -f /etc/apache2/sites-enabled/000-default.conf

ADD conf/website.conf /etc/apache2/conf.d/website.conf
ADD conf/httpd.conf /etc/apache2/apache2.conf
ADD conf/php.ini /etc/php5/apache2/php.ini
ADD conf/postfix.cf /etc/postfix/main.cf
ADD conf/sasl_passwd /etc/postfix/sasl_passwd

RUN mkdir -p /etc/service/lamp
ADD conf/lamp.sh /etc/service/lamp/run
RUN chmod +x /etc/service/lamp/run

RUN chown -R postfix:postfix /etc/postfix
RUN chmod 600 /etc/postfix/sasl_passwd
RUN postmap /etc/postfix/sasl_passwd

RUN apachectl configtest
RUN rm -rf /var/www

RUN service apache2 stop
RUN service postfix stop

EXPOSE 80
EXPOSE 443

CMD ["/sbin/my_init"]
