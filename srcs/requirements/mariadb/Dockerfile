# the containers must be built either from the penultimate stable version of Alpine or Debian.
## https://hub.docker.com/_/debian
FROM debian:12.5-slim

# A Docker container that contains MariaDB only without nginx.
RUN apt-get update &&\
    apt-get -y install mariadb-server

## Recieve the environment variables from the docker-compose.yml file.
ARG MARIADB_ROOT_PASSWORD
ARG MARIADB_DATABASE
ARG MARIADB_USER1
ARG MARIADB_USER1_PASSWORD

## COPY the configuration file.
COPY requirements/mariadb/conf/port_inception.cnf /etc/mysql/mariadb.conf.d/port_inception.cnf

## create a database and a user for WordPress.
## rootのパスワードは設定しなくても動作してそうだが、subjectの例に載ってたので設定しておいた。
RUN service mariadb start &&\
    mariadb --execute "CREATE DATABASE ${MARIADB_DATABASE};" &&\
    mariadb --execute "CREATE USER '${MARIADB_USER1}'@'%' IDENTIFIED BY '${MARIADB_USER1_PASSWORD}';" &&\
    mariadb --execute "GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER1}'@'%';" &&\
    mariadb --execute "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MARIADB_ROOT_PASSWORD}');" &&\
    mariadb --execute "FLUSH PRIVILEGES;"

## set the user"mysql" can run the command "mariadbd".
## default mysql user has no home directory, shell, and path to the command "mariadbd".
RUN mkdir /home/mysql &&\
    usermod -d /home/mysql mysql &&\
    usermod -s /bin/bash mysql &&\
    echo 'export PATH=$PATH:/usr/sbin' >> /home/mysql/.bashrc

## clean up to reduce the size of the image
RUN apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

## run services background.
USER mysql
ENTRYPOINT ["mariadbd"]