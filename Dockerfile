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
slapd ldap-utils php-ldap locate php-zip git

# Utilisateur de travail
RUN adduser --disabled-password --gecos '' libertempo && \
    adduser libertempo sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configuration apache
COPY ./config/apache/sites/* /etc/apache2/sites-available/
RUN a2enmod rewrite && \
    a2ensite 001-libertempo.conf && \
    a2ensite 002-libertempo-api.conf && \
    service apache2 restart

# MySQL
RUN service mysql start

# LDAP
RUN chown -R openldap: /etc/ldap && \
{ \
    echo slapd slapd/internal/generated_adminpw password 'admin'; \
    echo slapd slapd/internal/adminpw password 'admin'; \
    echo slapd slapd/password2 password 'admin'; \
    echo slapd slapd/password1 password 'admin'; \
    echo slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION; \
    echo slapd slapd/domain string 'libertempo'; \
    echo slapd shared/organization string 'libertempo' \
    echo slapd slapd/backend string 'HDB' \
    echo slapd slapd/purge_database boolean true; \
    echo slapd slapd/move_old_database boolean true; \
    echo slapd slapd/allow_ldap_v2 boolean false; \
    echo slapd slapd/no_configuration boolean false; \
    echo slapd slapd/dump_database select when needed; \
} | debconf-set-selections && \
    dpkg-reconfigure -f noninteractive slapd && \
    service slapd restart

# Misc
RUN mkdir /opt/run
COPY ./tools/* /opt/run/
COPY ./config/mysql/my.cnf /etc/mysql/
COPY ./config/php/xdebug.ini /etc/php/mods-available/

COPY bootstrap.sh /opt/run/
RUN chmod +x /opt/run/bootstrap.sh && \
    chmod +x /opt/run/add_users_ldap.sh

USER libertempo
WORKDIR /var/www
CMD ["/bin/bash"]
