.PHONY: up down ps

DOCKER_COMPOSE_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(DOCKER_COMPOSE_DIR)/docker-compose.yml
DOCKER_VOLUME_DIR = /tmp/sotanaka/data

up: build
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v && rm -rf $(DOCKER_VOLUME_DIR)/*

ps:
	docker compose -f $(DOCKER_COMPOSE_FILE) ps

build:
	docker compose -f $(DOCKER_COMPOSE_FILE) build --no-cache