.DEFAULT_GOAL := start
APACHE_IP = $(shell docker inspect --format '{{ .NetworkSettings.Networks.docker_libertempo.IPAddress }}' lt-httpd)
PHP_APP_DIR = /srv/app
NOM_INSTANCE = libertempo
WEB_USER = www-data

clean:
	docker system prune -f
	docker container prune -f
	docker image prune -f
	docker volume prune -f
	docker network prune -f

start:
	docker-compose start

attach:
	docker exec -it -u libertempo lt-base bash

stop:
	docker-compose stop

down:
	docker-compose --compatibility down

set-env:
	cp .env.dist .env

build:
	docker-compose --compatibility up --build -d

rebuild: down build

ldap-add-user:
	docker exec lt-ldap /opt/run/add_users_ldap.sh

install: start
	@echo "Installation de l'application…"
	@docker exec lt-php bash -c "echo '${APACHE_IP} ${NOM_INSTANCE}' >> /etc/hosts"
	@echo "Please run make autoinstall..."
	@docker exec -ti -w ${PHP_APP_DIR}/web -u ${WEB_USER} lt-php bash
