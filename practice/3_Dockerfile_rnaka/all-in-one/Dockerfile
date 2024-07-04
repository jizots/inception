FROM debian:latest
RUN apt update
RUN apt install -y vim wget unzip
RUN apt install -y nginx
RUN apt install -y php-fpm php-mysqli php-gd php-curl php-xml php-mbstring php-zip
RUN apt install -y mariadb-server

CMD ["nginx", "-g", "daemon off;"]