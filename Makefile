.DEFAULT_GOAL := start

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

install:
	@echo "Installation de l'application…"
	docker exec -w /srv/app/web lt-php bash -c "make nom_instance=http://libertempo/ install"
