FROM wordpress:latest

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    less

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN wp core download --allow-root

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
