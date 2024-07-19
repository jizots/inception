# the containers must be built either from the penultimate stable version of Alpine or Debian.
## https://hub.docker.com/_/debian
FROM debian:12.5-slim

# A Docker container that contains MariaDB only without nginx.
RUN apt-get update
RUN apt-get -y install mariadb-server

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
    mariadb --execute "FLUSH PRIVILEGES;" &&\
    # mariadb --execute "SET GLOBAL general_log = 'ON';" &&\
    # mariadb --execute "SET GLOBAL general_log_file = '/var/log/mysql/general.log';" &&\
    service mariadb stop

## set the user"mysql" can run the command "mariadbd".
## default mysql user has no home directory, shell, and path to the command "mariadbd".
RUN mkdir /home/mysql &&\
    usermod -d /home/mysql mysql &&\
    usermod -s /bin/bash mysql &&\
    echo 'export PATH=$PATH:/usr/sbin' >> /home/mysql/.bashrc

## clean up to reduce the size of the image
RUN apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

USER mysql

# After container started, run services background.
ENTRYPOINT ["mariadbd"]

## packages include in "apt-get install mariadb-server"
# galera-4 gawk iproute2 libatm1 libbpf1 libcap2-bin libcgi-fast-perl libcgi-pm-perl libclone-perl libconfig-inifiles-perl
# libdaxctl1 libdbd-mariadb-perl libdbi-perl libelf1 libencode-locale-perl libfcgi-bin libfcgi-perl libfcgi0ldbl
# libgdbm-compat4 libgdbm6 libhtml-parser-perl libhtml-tagset-perl libhtml-template-perl libhttp-date-perl libhttp-message-perl
# libio-html-perl liblwp-mediatypes-perl liblzo2-2 libmariadb3 libmnl0 libmpfr6 libncurses6 libndctl6 libnsl2 libnuma1
# libpam-cap libperl5.36 libpmem1 libpopt0 libreadline8 libregexp-ipv6-perl libsigsegv2 libsnappy1v5 libterm-readkey-perl
# libtimedate-perl libtirpc-common libtirpc3 liburi-perl liburing2 libwrap0 libxtables12 lsof mariadb-client
# mariadb-client-core mariadb-common mariadb-plugin-provider-bzip2 mariadb-plugin-provider-lz4 mariadb-plugin-provider-lzma
# mariadb-plugin-provider-lzo mariadb-plugin-provider-snappy mariadb-server-core mysql-common netbase perl perl-modules-5.36 pv
# readline-common rsync socat