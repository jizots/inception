# the containers must be built either from the penultimate stable version of Alpine or Debian.
# https://hub.docker.com/_/debian
FROM debian:12.5-slim

# A Docker container that contains WordPress + php-fpm (it must be installed and configured)
# only without nginx.

## package wget: ca-certificates libpsl5 libssl3 openssl publicsuffix wget
## package unzip: unzip
RUN apt-get update &&\
    apt-get -y install \
    wget \
    php-fpm

RUN wget https://wordpress.org/latest.tar.gz &&\
    tar -xvzf latest.tar.gz &&\
    rm latest.tar.gz

## Install WP-CLI
RUN apt-get -y install \
    curl
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
## why need to run wp core download --allow-root?
# RUN wp core download --allow-root

# For verify command
CMD ["sleep", "infinity"]
