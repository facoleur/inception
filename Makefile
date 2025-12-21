all: up

up:
	docker compose -f ./srcs/docker-compose.yml  up -d

down:
	docker compose -f ./srcs/docker-compose.yml  down

build:
	docker compose -f ./srcs/docker-compose.yml  build --no-cache

clean: down
	docker system prune -af --volumes
