#!/bin/bash

## When error occurred, stop the script.
set -e

## Wait for the MariaDB service to be available. 
## ヘルスチェックが終わってても少しディレイがあるのか、直後に接続しようとすると失敗することがある
until mariadb -h "${WORDPRESS_DB_HOST_NAMEONLY}" -u "${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "SHOW DATABASES;" > /dev/null 2>&1; do
  echo "Waiting for database connection..."
  sleep 3
done

## WordPressの設定ファイルが存在しない場合、設定ファイルを作成する。
## ボリュームをマウントしている場合は、設定ファイルが既に存在する可能性があるので、
## その場合は設定ファイルを新規作成しない。
if [ ! -f /var/www/html/wp-config.php ]; then
  wp core config \
    --dbname=${WORDPRESS_DB_NAME} \
    --dbuser=${WORDPRESS_DB_USER} \
    --dbpass=${WORDPRESS_DB_PASSWORD} \
    --dbhost=${WORDPRESS_DB_HOST}
fi

## WordPressのインストールがされていない場合、WordPressをインストールする。
if ! wp core is-installed; then
  ## WordPressのインストール
  wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email
fi

# php-fpmを起動
exec sudo -E php-fpm8.2 -F
