# Doc : https://hub.docker.com/_/php/
FROM php:7.1-apache

RUN apt update && \
    apt install -y -q --no-install-recommends sudo vim locate mysql-client gettext ldap-utils libldap2-dev locales gnupg git unzip zlib1g-dev && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt install -y nodejs && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure ldap --with-libdir="lib/x86_64-linux-gnu/" && \
    docker-php-ext-install -j"$(nproc)" mysqli gettext pdo_mysql ldap zip

COPY ./sites/* /etc/apache2/sites-available/
RUN a2enmod rewrite && \
    a2ensite 001-libertempo.conf && \
    a2ensite 002-libertempo-api.conf

#RUN pecl install xdebug-2.6.0 \
#    && docker-php-ext-enable xdebug

# Configuration
COPY ./my.cnf /etc/mysql/
COPY ./ldap.conf /etc/ldap/
# Set the locale
RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:fr
#ENV LC_ALL en_US.UTF-8

# LDAP
COPY ./content.ldif /opt/run/
COPY ./add_users_ldap.sh /opt/run/
RUN chmod +x /opt/run/add_users_ldap.sh

## Utilisateur de travail (manipulation composer, etc)
ARG UID
ARG GID
RUN adduser --disabled-password --gecos '' libertempo && \
    adduser libertempo sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    usermod -u $UID libertempo && \
    groupmod -g $GID libertempo

# Colored prompt
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\\w\[\033[00m\]\$ '" >> /home/libertempo/.bashrc

#
# Misc
#COPY ./config/php/xdebug.ini /etc/php/mods-available/
#
#
#USER libertempo
WORKDIR /var/www
