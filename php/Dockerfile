# Cf. http://www.inanzzz.com/index.php/post/su76/creating-apache-mysql-and-php-fpm-containers-for-a-web-application-with-docker-compose
FROM php:7.1-fpm-alpine3.9

ARG UID
ARG GID
ARG WEB_USER
ARG WEB_GROUP
ARG PHP_ROOT_DIR
ARG PHP_APP_DIR

# PHPIZE_DEPS=autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c
RUN apk add --no-cache unzip $PHPIZE_DEPS npm libintl openldap-clients openldap-dev bash && \
    apk add --no-cache -t builder gettext-dev shadow libzip-dev && \
    docker-php-ext-install -j"$(nproc)" ldap mysqli gettext pdo_mysql calendar && \
    pecl install xdebug-2.6.0 && \
    docker-php-ext-enable xdebug && \
    usermod -u ${UID} ${WEB_USER} && \
    groupmod -g ${GID} ${WEB_GROUP} && \
#    chgrp -R staff ${PHP_ROOT_DIR}/php-fpm.d/www.conf
    apk del builder autoconf dpkg-dev dpkg file g++ gcc libc-dev pkgconf re2c && \
    rm -rf /var/cache/apk/*

COPY www.conf ${PHP_ROOT_DIR}/php-fpm.d/www.conf
COPY ./ldap.conf /etc/openldap/

# Set the locale
#RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
#    locale-gen
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
#ENV LC_ALL en_US.UTF-8

WORKDIR ${PHP_APP_DIR}
