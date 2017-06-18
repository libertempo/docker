#!/bin/bash
echo "Starting mysql service"
service mysql start

echo "Create DB if not exists"
echo "CREATE DATABASE IF NOT EXISTS db_conges" | mysql

echo "Starting apache service"
service apache2 start

chown -R openldap: /etc/ldap
#chown -R openldap: /opt/run/content.ldif

echo "Starting ldap service"
service slapd start

CMD="$(ldapsearch -x -LLL -H ldap:/// -b dc=libertempo dn)"
RETURN_VAL=$?
if [[ 0 != "${RETURN_VAL}" ]]; then
    echo "Boot ldap server"

    cat <<EOF | debconf-set-selections
slapd slapd/internal/generated_adminpw password admin
slapd slapd/internal/adminpw password admin
slapd slapd/password2 password admin
slapd slapd/password1 password admin
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/domain string libertempo
slapd shared/organization string libertempo
slapd slapd/backend string HDB
slapd slapd/purge_database boolean true
slapd slapd/move_old_database boolean true
slapd slapd/allow_ldap_v2 boolean false
slapd slapd/no_configuration boolean false
slapd slapd/dump_database select when needed
EOF

    dpkg-reconfigure -f noninteractive slapd
    service slapd restart
fi

/bin/bash
