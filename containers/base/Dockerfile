# Doc : https://hub.docker.com/_/php/
FROM php:7.0-apache
MAINTAINER Prytoegrian <prytoegrian@protonmail.com>

RUN apt update \
&& apt install -y -q --no-install-recommends sudo vim locate mysql-client gettext ldap-utils libldap2-dev

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install -j$(nproc) mysqli gettext pdo_mysql ldap

COPY ./sites/* /etc/apache2/sites-available/
RUN a2enmod rewrite && \
    a2ensite 001-libertempo.conf && \
    a2ensite 002-libertempo-api.conf

RUN pecl install xdebug-2.6.0 \
    && docker-php-ext-enable xdebug

# Configuration
COPY ./my.cnf /etc/mysql/
COPY ./ldap.conf /etc/ldap/

# LDAP
COPY ./content.ldif /opt/run/
COPY ./add_users_ldap.sh /opt/run/
RUN chmod +x /opt/run/add_users_ldap.sh

## Utilisateur de travail (manipulation composer, etc)
RUN adduser --disabled-password --gecos '' libertempo && \
    adduser libertempo sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#
# Misc
#COPY ./config/php/xdebug.ini /etc/php/mods-available/
#
#
#USER libertempo
WORKDIR /var/www
