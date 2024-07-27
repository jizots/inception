.PHONY: up down ps

# docker-compose.ymlがあるディレクトリのパス
DOCKER_COMPOSE_DIR = ./srcs
DOCKER_COMPOSE_FILE = $(DOCKER_COMPOSE_DIR)/docker-compose.yml

# ボリュームをマウントするディレクトリのパス
DOCKER_VOLUME_DIR_ROOT = /tmp/sotanaka/
DOCKER_VOLUME_DIR_PAIR = $(DOCKER_VOLUME_DIR_ROOT)data/
DOCKER_VOLUME_DIR_MARIADB = $(DOCKER_VOLUME_DIR_PAIR)mariadb/
DOCKER_VOLUME_DIR_WORDPRESS = $(DOCKER_VOLUME_DIR_PAIR)wordpress/

# /etc/hostsに追加するホスト名とIPアドレス
IP_ADDRESS_WORDPRESS = 127.0.0.1
HOSTNAME_WORDPRESS = sotanaka.42.fr

IP_ADDRESS_ADMINER = 127.0.0.1
HOSTNAME_ADMINER = adminer.42.fr

up: build add_host
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

# /etc/hostsになければ追加
add_host:
	if grep -q "$(HOSTNAME_WORDPRESS)" /etc/hosts; then \
		echo "$(HOSTNAME_WORDPRESS) already exists in /etc/hosts"; \
	else \
		echo "Adding entry to /etc/hosts"; \
		echo "$(IP_ADDRESS_WORDPRESS) $(HOSTNAME_WORDPRESS)" | sudo tee -a /etc/hosts; \
	fi

	if grep -q "$(HOSTNAME_ADMINER)" /etc/hosts; then \
		echo "$(HOSTNAME_ADMINER) already exists in /etc/hosts"; \
	else \
		echo "Adding entry to /etc/hosts"; \
		echo "$(IP_ADDRESS_ADMINER) $(HOSTNAME_ADMINER)" | sudo tee -a /etc/hosts; \
	fi

# For debug
re:	down clean up image-prune
