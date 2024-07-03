# dockerの.ymlファイルの使い方と、makefileでどのように.ymlファイルを実行するか、を知る

.PHONY: setup up d b ps node

setup:
	@make up
	@make ps

d:
	docker compose down

# targetに対して、コマンドを素直に記述してるだけ。依存関係はない。
up:
	docker compose -f ./src/docker-compose.yml up -d

ps:
	docker compose ps

node:
	docker compose exec node bash
