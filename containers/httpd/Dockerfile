# Doc : https://hub.docker.com/_/php/
FROM httpd:2.4-alpine

ARG UID
ARG GID
ARG WEB_USER
ARG WEB_GROUP
ARG APACHE_ROOT_DIR

RUN apk add gettext nodejs shadow

COPY httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
COPY httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf

RUN mkdir -p ${APACHE_ROOT_DIR}/htdocs/api/Public && \
    usermod -u ${UID} ${WEB_USER} && \
    groupmod -g ${GID} ${WEB_GROUP} && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}

