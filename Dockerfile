FROM centos:latest
MAINTAINER Matej Kramny <matej@matej.me>

RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum update -y
RUN yum install -y httpd php php-mysql php-pecl php-pear php-pdo php-xml php-odbc mysql curl git postfix cyrus-sasl-plain
RUN pear install Mail Mail_Mime Net_SMTP Net_Socket Spreadsheet_Excel_Writer XML_RPC

EXPOSE 80

ADD conf/website.conf /etc/httpd/conf.d/website.conf
ADD conf/httpd.conf /etc/httpd/conf/httpd.conf
ADD conf/php.ini /etc/php.ini

RUN rm -f /etc/httpd/conf.d/welcome.conf
RUN apachectl configtest

RUN rm -rf /var/www

RUN service httpd stop

RUN source /etc/sysconfig/httpd
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
