# Doc : https://hub.docker.com/_/php/
FROM php:7.0-apache
MAINTAINER Prytoegrian <prytoegrian@protonmail.com>

RUN apt update \
&& apt install -y -q --no-install-recommends sudo vim locate mysql-client gettext

RUN docker-php-ext-install -j$(nproc) mysqli gettext pdo_mysql

COPY ./sites/* /etc/apache2/sites-available/
RUN a2enmod rewrite && \
    a2ensite 001-libertempo.conf && \
    a2ensite 002-libertempo-api.conf

RUN pecl install xdebug-2.6.0 \
    && docker-php-ext-enable xdebug

# Configuration
COPY ./my.cnf /etc/mysql/


## Utilisateur de travail (manipulation composer, etc)
RUN adduser --disabled-password --gecos '' libertempo && \
    adduser libertempo sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#
# Misc
#COPY ./tools/* /opt/run/
#COPY ./config/php/xdebug.ini /etc/php/mods-available/
#
#RUN chmod +x /opt/run/add_users_ldap.sh
#
#USER libertempo
WORKDIR /var/www
