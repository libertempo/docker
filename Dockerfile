FROM ubuntu:14.04
MAINTAINER Prytoegrian <prytoegrian@protonmail.com>

RUN apt-get update -qq && apt-get install -y -qq mysql-client mysql-server vim apache2 libapache2-mod-php5 language-pack-fr php5 php5-mysqlnd php5-dev php5-xdebug php5-curl
RUN a2enmod rewrite

COPY ./config/apache/sites/* /etc/apache2/sites-available/
RUN a2ensite 001-libertempo.conf
RUN a2ensite 002-libertempo-api.conf
COPY ./config/test/atoum /usr/bin/
RUN mkdir /opt/run
COPY ./tools/atoum.phar /opt/run/
COPY ./config/mysql/my.cnf /etc/mysql/
COPY ./config/php/xdebug.ini /etc/php5/mods-available/

ADD bootstrap.sh /opt/run/
RUN chmod +x /opt/run/bootstrap.sh

WORKDIR /var/www/libertempo
CMD ["/opt/run/bootstrap.sh"]
