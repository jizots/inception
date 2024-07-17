#!/bin/bash
set -e

# Wait for the MariaDB service to be available
until mariadb -h "${WORDPRESS_DB_HOST_NAMEONLY}" -u "${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "SHOW DATABASES;" > /dev/null 2>&1; do
  echo "Waiting for database connection..."
  sleep 3
done

# WordPress設定を行う
if [ ! -f /var/www/html/wp-config.php ]; then
  wp core config \
    --dbname=${WORDPRESS_DB_NAME} \
    --dbuser=${WORDPRESS_DB_USER} \
    --dbpass=${WORDPRESS_DB_PASSWORD} \
    --dbhost=${WORDPRESS_DB_HOST}
fi

# php-fpmを起動
exec sudo -E php-fpm8.2 -F
