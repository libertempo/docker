FROM actualys/ldap:1.1

COPY ./ldap.conf /etc/ldap/
COPY ./content.ldif /opt/run/
COPY ./add_users_ldap.sh /opt/run/
RUN chmod u+x /opt/run/add_users_ldap.sh
