# the containers must be built either from the penultimate stable version of Alpine or Debian.
# https://hub.docker.com/_/debian
FROM debian:12.5-slim

## recieve the environment variables from the docker-compose.yml file.
ARG WORDPRESS_DB_HOST
ARG WORDPRESS_DB_NAME
ARG WORDPRESS_DB_USER
ARG WORDPRESS_DB_PASSWORD

# A Docker container that contains WordPress + php-fpm (it must be installed and configured)
# only without nginx.
## install wget and php-fpm
RUN apt-get update &&\
    apt-get -y install \
    wget \
    php8.2-fpm

## download WordPress
RUN wget https://wordpress.org/latest.tar.gz &&\
    tar -xvzf latest.tar.gz &&\
    rm latest.tar.gz &&\
    mkdir -p /var/www/html &&\
    sleep 2 &&\
    cp -r /wordpress/* /var/www/html/ &&\
    rm -rf /wordpress/

## Install WP-CLI
RUN apt-get -y install \
    curl &&\
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
    chmod +x wp-cli.phar &&\
    mv wp-cli.phar /usr/local/bin/wp

## Configure WordPress
### create wordpress group and user to avoid permission issues
RUN groupadd ${WORDPRESS_DB_NAME} &&\
    useradd -g ${WORDPRESS_DB_NAME} ${WORDPRESS_DB_USER} &&\
    mkdir -p /home/${WORDPRESS_DB_NAME}



# For verify command
CMD ["sleep", "infinity"]

## packages include in ... ##
## wget: ca-certificates libpsl5 libssl3 openssl publicsuffix wget
## unzip: unzip
## php-fpm: dbus dbus-bin dbus-daemon dbus-session-bus-common dbus-system-bus-common dmsetup libapparmor1 libargon2-1 libcryptsetup12
##   libdbus-1-3 libdevmapper1.02.1 libedit2 libexpat1 libfdisk1 libgpm2 libicu72 libip4tc2 libjson-c5 libkmod2 libmagic-mgc
##   libmagic1 libncursesw6 libproc2-0 libsodium23 libsystemd-shared libsystemd0 libudev1 libxml2 media-types php-common
##   php8.2-cli php8.2-common php8.2-opcache php8.2-readline procps psmisc sensible-utils systemd systemd-timesyncd ucf
## end of packages section ##