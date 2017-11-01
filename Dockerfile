FROM ubuntu:15.04
MAINTAINER Prytoegrian <prytoegrian@protonmail.com>

RUN apt-get update -qq \
&& { \
    echo debconf debconf/frontend select Noninteractive; \
    echo mysql-community-server mysql-community-server/root-pass \
    password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass \
    password ''; \
} | debconf-set-selections \
&& apt-get install -y -qq apt-utils mysql-client mysql-server \
vim apache2 libapache2-mod-php5 language-pack-fr php5 php5-mysql php5-dev php5-xdebug php5-curl \
slapd ldap-utils php5-ldap locate
RUN a2enmod rewrite

COPY ./config/apache/sites/* /etc/apache2/sites-available/
RUN a2ensite 001-libertempo.conf
RUN a2ensite 002-libertempo-api.conf
COPY ./config/test/atoum /usr/bin/
RUN mkdir /opt/run
COPY ./tools/* /opt/run/
COPY ./config/mysql/my.cnf /etc/mysql/
COPY ./config/php/xdebug.ini /etc/php5/mods-available/

ADD bootstrap.sh /opt/run/
RUN chmod +x /opt/run/bootstrap.sh
RUN chmod +x /opt/run/add_users_ldap.sh

WORKDIR /var/www/libertempo
CMD ["/opt/run/bootstrap.sh"]
