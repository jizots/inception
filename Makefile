.PHONY: up down ps

DOCKER_COMPOSE_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(DOCKER_COMPOSE_DIR)/docker-compose.yml

up:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -d

ps:
	docker compose -f $(DOCKER_COMPOSE_FILE) ps -d
