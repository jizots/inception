.PHONY: up down ps

DOCKER_COMPOSE_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(DOCKER_COMPOSE_DIR)/docker-compose.yml
DOCKER_VOLUME_DIR_MARIADB = /tmp/sotanaka/data/mariadb/
DOCKER_VOLUME_DIR_WORDPRESS = /tmp/sotanaka/data/wordpress/

up: build
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

# For debug. Volumeが残っているとまた同じデータが使われるので削除する
clean:
	rm -rf $(DOCKER_VOLUME_DIR_MARIADB)*
	rm -rf $(DOCKER_VOLUME_DIR_WORDPRESS)*

ps:
	docker compose -f $(DOCKER_COMPOSE_FILE) ps

build:
	docker compose -f $(DOCKER_COMPOSE_FILE) build --no-cache

# For debug
re:	down clean up
