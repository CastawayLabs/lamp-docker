FROM centos:latest
MAINTAINER Matej Kramny <matej@matej.me>

RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum update
RUN yum install -y httpd php php-mysql php-pecl php-pear php-pdo php-xml curl git

EXPOSE 80

ADD www/ /var/www/
#ADD conf/supervisord.conf /etc/supervisord.conf
ADD conf/httpd.conf /etc/httpd/conf.d/website.conf

RUN rm -f /etc/httpd/conf.d/welcome.conf
RUN apachectl configtest

RUN service httpd stop

RUN source /etc/sysconfig/httpd
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
