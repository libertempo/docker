FROM php:7.1-fpm

ARG UID
ARG GID
ARG WEB_USER
ARG WEB_GROUP
ARG PHP_ROOT_DIR
ARG PHP_APP_DIR

RUN apt update && \
    apt install -y -q --no-install-recommends ldap-utils libldap2-dev locales gnupg git unzip zlib1g-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
   
RUN docker-php-ext-configure ldap --with-libdir="lib/x86_64-linux-gnu/" && \
    docker-php-ext-install -j"$(nproc)" mysqli gettext pdo_mysql ldap zip

COPY www.conf ${PHP_ROOT_DIR}/php-fpm.d/www.conf
    
RUN usermod -u ${UID} ${WEB_USER} && \
    groupmod -g ${GID} ${WEB_GROUP} && \
    chgrp -R staff ${PHP_ROOT_DIR}/php-fpm.d/www.conf

COPY index.php ${PHP_APP_DIR}/index.php
COPY index.php ${PHP_APP_DIR}/index2.php

# Set the locale
RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
#ENV LC_ALL en_US.UTF-8

# Configuration
COPY ./ldap.conf /etc/ldap/

# LDAP
COPY ./content.ldif /opt/run/
COPY ./add_users_ldap.sh /opt/run/
RUN chmod +x /opt/run/add_users_ldap.sh
