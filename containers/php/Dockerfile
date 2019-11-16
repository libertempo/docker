# Cf. http://www.inanzzz.com/index.php/post/su76/creating-apache-mysql-and-php-fpm-containers-for-a-web-application-with-docker-compose
FROM php:7.1-fpm-alpine3.9

ARG UID
ARG GID
ARG WEB_USER
ARG WEB_GROUP
ARG PHP_ROOT_DIR
ARG PHP_APP_DIR

RUN apk add --no-cache gettext-dev unzip shadow libzip-dev $PHPIZE_DEPS && \
    docker-php-ext-install -j"$(nproc)" mysqli gettext pdo_mysql calendar && \
    pecl install xdebug-2.6.0 && \
    docker-php-ext-enable xdebug && \
    apk del $PHPIZE_DEPS && \
    rm -rf /var/cache/apk/*

COPY www.conf ${PHP_ROOT_DIR}/php-fpm.d/www.conf

RUN usermod -u ${UID} ${WEB_USER} && \
    groupmod -g ${GID} ${WEB_GROUP}
#    chgrp -R staff ${PHP_ROOT_DIR}/php-fpm.d/www.conf

# Set the locale
#RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
#    locale-gen
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
#ENV LC_ALL en_US.UTF-8

# Configuration
# TO DROP
COPY ./ldap.conf /etc/ldap/
COPY ./content.ldif /opt/run/
COPY ./add_users_ldap.sh /opt/run/
RUN chmod +x /opt/run/add_users_ldap.sh

WORKDIR ${PHP_APP_DIR} 
