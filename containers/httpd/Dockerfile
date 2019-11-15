# Doc : https://hub.docker.com/_/php/
FROM httpd:2.4

ARG UID
ARG GID
ARG WEB_USER
ARG WEB_GROUP
ARG APACHE_ROOT_DIR

RUN apt update && \
    apt install -y -q --no-install-recommends gettext ldap-utils libldap2-dev locales gnupg git unzip zlib1g-dev curl && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt install -y nodejs && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
COPY httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf

RUN mkdir ${APACHE_ROOT_DIR}/web && mkdir -p ${APACHE_ROOT_DIR}/api/Public
# COPY ./sites/* /etc/apache2/sites-available/
#RUN a2ensite 001-libertempo.conf && \
#    a2ensite 002-libertempo-api.conf

# Configuration
COPY ./ldap.conf /etc/ldap/

RUN usermod -u ${UID} ${WEB_USER} && \
    groupmod -g ${GID} ${WEB_GROUP} && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}

# Colored prompt
# RUN echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;33m\]\\w\[\033[00m\]\$ '" >> /home/libertempo/.bashrc

#
# LDAP
COPY ./content.ldif /opt/run/
COPY ./add_users_ldap.sh /opt/run/
RUN chmod +x /opt/run/add_users_ldap.sh
