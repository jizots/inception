#!/bin/bash

# Install Apache if not already installed
if ! command -v apache2 &> /dev/null; then
    apt-get update && apt-get install -y apache2
fi

# Start Apache
apache2-foreground &

# Wait for MariaDB to be ready
while ! mariadb -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e 'show databases;' &> /dev/null; do
    echo "Waiting for MariaDB..."
    sleep 3
done

# Run the WordPress installation commands
wp core config \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --allow-root

wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --allow-root

exec "$@"