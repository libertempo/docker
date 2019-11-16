FROM mysql:8.0.11

ARG UID
ARG GID
ARG MYSQL_CONTAINER_USER
ARG MYSQL_CONTAINER_GROUP
  
#RUN sed -i "s/#log-error/log-error/g" /etc/mysql/mysql.conf.d/mysqld.cnf
   
#RUN usermod -u ${UID} ${MYSQL_CONTAINER_USER} \
#    && groupmod -g ${GID} ${MYSQL_CONTAINER_GROUP}
## Configuration
#COPY ./my.cnf /etc/mysql/
#RUN mkdir /var/lib/mysql-files
