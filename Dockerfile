FROM ubuntu:16.04
MAINTAINER Prytoegrian <prytoegrian@protonmail.com>

RUN apt update -qq \
&& { \
    echo debconf debconf/frontend select Noninteractive; \
    echo mysql-community-server mysql-community-server/root-pass \
    password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass \
    password ''; \
} | debconf-set-selections \
&& apt install -y -qq sudo apt-utils mysql-client mysql-server \
vim apache2 libapache2-mod-php language-pack-fr php php-mysql php-dev php-xdebug php-curl php-mbstring \
slapd ldap-utils php-ldap locate

# Utilisateur de travail
RUN useradd -m libertempo -s /bin/bash

# Configuration apache
COPY ./config/apache/sites/* /etc/apache2/sites-available/
RUN a2enmod rewrite && \
    a2ensite 001-libertempo.conf && \
    a2ensite 002-libertempo-api.conf

# Misc
RUN mkdir /opt/run
COPY ./tools/* /opt/run/
COPY ./config/mysql/my.cnf /etc/mysql/
COPY ./config/php/xdebug.ini /etc/php/mods-available/

COPY bootstrap.sh /opt/run/
RUN chmod +x /opt/run/bootstrap.sh && \
    chmod +x /opt/run/add_users_ldap.sh

CMD ["/opt/run/bootstrap.sh"]
