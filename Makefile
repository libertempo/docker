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
	docker exec -it lt-base bash

stop:
	docker-compose stop

down:
	docker-compose down

build: down
	docker-compose up --build -d

install:
	@echo "Installation de l'application…"
	docker exec -w /var/www/web lt-base bash -c "make nom_instance=http://libertempo/ install"
