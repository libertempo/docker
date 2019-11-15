# Doc : https://hub.docker.com/_/php/
FROM httpd:2.4

ARG UID
ARG GID
ARG WEB_USER
ARG WEB_GROUP
ARG APACHE_ROOT_DIR

RUN apt update && \
    apt install -y -q --no-install-recommends gettext gnupg git unzip zlib1g-dev && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt install -y nodejs && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
COPY httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf

RUN mkdir ${APACHE_ROOT_DIR}/htdocs/web && mkdir -p ${APACHE_ROOT_DIR}/htdocs/api/Public

RUN usermod -u ${UID} ${WEB_USER} && \
    groupmod -g ${GID} ${WEB_GROUP} && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}

