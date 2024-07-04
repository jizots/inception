.PHONY: setup up d b ps node

setup:
	@make up
	@make ps

d:
	docker compose -f /Users/sotanaka/inception/practice/p2/srcs/docker-compose.yml down

up:
	docker compose -f /Users/sotanaka/inception/practice/p2/srcs/docker-compose.yml up -d

ps:
	docker compose ps

node:
	docker compose exec node bash