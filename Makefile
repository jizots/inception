.PHONY: up down ps

DOCKER_COMPOSE_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(DOCKER_COMPOSE_DIR)/docker-compose.yml
DOCKER_VOLUME_DIR_ROOT = /tmp/sotanaka/
DOCKER_VOLUME_DIR_PAIR = $(DOCKER_VOLUME_DIR_ROOT)data/
DOCKER_VOLUME_DIR_MARIADB = $(DOCKER_VOLUME_DIR_PAIR)mariadb/
DOCKER_VOLUME_DIR_WORDPRESS = $(DOCKER_VOLUME_DIR_PAIR)wordpress/

up: build
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

dir:
	mkdir -p $(DOCKER_VOLUME_DIR_ROOT)
	mkdir -p $(DOCKER_VOLUME_DIR_PAIR)
	mkdir -p $(DOCKER_VOLUME_DIR_MARIADB)
	mkdir -p $(DOCKER_VOLUME_DIR_WORDPRESS)

down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v

# For debug. Volumeが残っているとまた同じデータが使われるので削除する
clean:
	rm -rf $(DOCKER_VOLUME_DIR_MARIADB)*
	rm -rf $(DOCKER_VOLUME_DIR_WORDPRESS)*

ps:
	docker compose -f $(DOCKER_COMPOSE_FILE) ps

# 古いイメージを削除
image-prune:
	docker image prune -f

build: dir
	docker compose -f $(DOCKER_COMPOSE_FILE) build --no-cache

# For debug
re:	down clean re up
