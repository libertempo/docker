.DEFAULT_GOAL := start

init:
	docker-compose up --build -d

start:
	docker-compose up -d

stop:
	docker-compose down

attach:
	docker exec -it lt-base bash

install: init
	docker exec -w /var/www/web lt-base bash -c "make nom_instance=http://libertempo/ install"
