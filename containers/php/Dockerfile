FROM php:7.1-fpm

ARG UID
ARG GID
ARG WEB_USER
ARG WEB_GROUP
ARG PHP_ROOT_DIR

RUN apt update && \
    apt install -y -q --no-install-recommends sudo vim locate gettext ldap-utils libldap2-dev locales gnupg git unzip zlib1g-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
   
RUN docker-php-ext-configure ldap --with-libdir="lib/x86_64-linux-gnu/" && \
    docker-php-ext-install -j"$(nproc)" mysqli gettext pdo_mysql ldap zip

COPY www.conf ${PHP_ROOT_DIR}/php-fpm.d/www.conf
    
RUN usermod -u ${UID} ${WEB_USER} && \
    groupmod -g ${GID} ${WEB_GROUP} && \
    chgrp -R staff ${PHP_ROOT_DIR}/php-fpm.d/www.conf

