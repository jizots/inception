# the containers must be built either from the penultimate stable version of Alpine or Debian.
# https://hub.docker.com/_/debian
FROM debian:12.5-slim

## recieve the environment variables from the docker-compose.yml file.
ARG WORDPRESS_DB_NAME
ARG WORDPRESS_DB_USER

ARG EXECUTION_USER_GROUP=www-data

# A Docker container that contains WordPress + php-fpm (it must be installed and configured)
# only without nginx.
## install wget and php-fpm
RUN apt-get update
RUN apt-get -y install \
    wget \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    sudo
## install for debugging
RUN apt-get -y install \
    iproute2 \
    vim

## download WordPress
RUN wget https://wordpress.org/latest.tar.gz &&\
    tar -xvzf latest.tar.gz
## move WordPress to /var/www/html
RUN mkdir -p /var/www/html &&\
    cp -r /wordpress/* /var/www/html/ &&\
    rm latest.tar.gz &&\
    rm -rf /wordpress/

## Install WP-CLI
RUN apt-get -y install \
    curl
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
    chmod +x wp-cli.phar &&\
    mv wp-cli.phar /usr/local/bin/wp

## Copy the entrypoint scrypt file to the container
COPY requirements/wordpress/tools/entrypoint_connectDB.sh /var/www/html/entrypoint_connectDB.sh
RUN chmod +x /var/www/html/entrypoint_connectDB.sh

## Configure WordPress
### create wordpress group and user to avoid permission issues
RUN useradd -g ${EXECUTION_USER_GROUP} ${WORDPRESS_DB_USER} &&\
    mkdir -p /home/${EXECUTION_USER_GROUP}
RUN usermod -d /home/${EXECUTION_USER_GROUP} ${WORDPRESS_DB_USER}
RUN usermod -s /bin/bash ${WORDPRESS_DB_USER}

### set the user "${WORDPRESS_DB_USER}" can run the command "wp core config"
RUN chown -R ${WORDPRESS_DB_USER}:${EXECUTION_USER_GROUP} /var/log
RUN chown -R ${WORDPRESS_DB_USER}:${EXECUTION_USER_GROUP} /var/www/html
RUN mkdir -p /run/php &&\
    chown -R ${WORDPRESS_DB_USER}:${EXECUTION_USER_GROUP} /run/php

### set the user "${WORDPRESS_DB_USER}" can run the command "sudo" without password
RUN echo "${WORDPRESS_DB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

### change www.conf file to listen on port 9000
RUN sed -i 's|^listen =.*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

USER ${WORDPRESS_DB_USER}
WORKDIR /var/www/html

### create wp-config.php
ENTRYPOINT ["bash", "/var/www/html/entrypoint_connectDB.sh"]

## packages include in ... ##
## wget: ca-certificates libpsl5 libssl3 openssl publicsuffix wget
## unzip: unzip
## php8.2-fpm: dbus dbus-bin dbus-daemon dbus-session-bus-common dbus-system-bus-common dmsetup libapparmor1 libargon2-1 libcryptsetup12
##   libdbus-1-3 libdevmapper1.02.1 libedit2 libexpat1 libfdisk1 libgpm2 libicu72 libip4tc2 libjson-c5 libkmod2 libmagic-mgc
##   libmagic1 libncursesw6 libproc2-0 libsodium23 libsystemd-shared libsystemd0 libudev1 libxml2 media-types php-common
##   php8.2-cli php8.2-common php8.2-opcache php8.2-readline procps psmisc sensible-utils systemd systemd-timesyncd ucf
## php8.2-mysql: php8.2-mysql
## end of packages section ##