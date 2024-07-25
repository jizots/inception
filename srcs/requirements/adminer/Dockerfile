# the containers must be built either from the penultimate stable version of Alpine or Debian.
## https://hub.docker.com/_/debian
FROM debian:12.5-slim

## install the packages to run the Adminer.
RUN apt-get update
RUN apt-get -y install \
    php8.2-cli \
    php8.2-mysql \
    wget

## download the Adminer.
RUN mkdir -p /var/www/html/adminer
RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/adminer/index.php

## start the server.
CMD ["php", "-S", "0.0.0.0:9042", "-t", "/var/www/html/adminer"]

## packages include in "apt-get install xxx"
# php8.2-cli: libargon2-1 libbsd0 libedit2 libicu72 libmagic-mgc libmagic1 libsodium23 libssl3 libxml2 media-types
#    php-common php8.2-cli php8.2-common php8.2-opcache php8.2-readline psmisc sensible-utils ucf
# php8.2-mysql: php8.2-mysql
# wget: ca-certificates libpsl5 openssl publicsuffix wget