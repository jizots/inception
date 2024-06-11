FROM debian:latest

RUN apt update && \
    apt install -y vim wget unzip nginx && \
    apt install -y lsb-release apt-transport-https ca-certificates && \
    wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt update && \
    apt install -y php7.4-fpm php7.4-mysqli php7.4-gd php7.4-curl php7.4-xml php7.4-mbstring php7.4-zip

RUN apt install mariadb-server