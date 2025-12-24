.PHONY: all up down build clean re

DATA_DIR = /home/lferro/data
COMPOSE = docker compose -f ./srcs/docker-compose.yml

all: up

up:
	mkdir -p $(DATA_DIR)/wordpress $(DATA_DIR)/mariadb
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build --no-cache

clean:
	$(COMPOSE) down -v --rmi local

re: clean up
