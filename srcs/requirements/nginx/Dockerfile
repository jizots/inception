# the containers must be built either from the penultimate stable version of Alpine or Debian.
## https://hub.docker.com/_/debian
FROM debian:12.5-slim

# A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
## install nginx with specific version
RUN apt-get update &&\
    apt-get -y install nginx=1.22.*
    
## install openssl
## make a directory for the SSL certificate
## create a self-signed certificate
RUN apt-get -y install openssl &&\
mkdir etc/nginx/ssl_certs &&\
openssl req -x509 -nodes -days 5 -newkey rsa:2048 -keyout /etc/nginx/ssl_certs/nginx.key -out /etc/nginx/ssl_certs/nginx.crt -subj '/CN=sotanaka.42.fr'

## copy the configuration file
COPY requirements/nginx/conf/nginx.conf /etc/nginx/nginx.conf

## delete the default configuration file
RUN rm /etc/nginx/sites-enabled/default

## clean up to reduce the size of the image
RUN apt-get clean &&\
    rm -rf /var/lib/apt/lists/*
    
## For the container to listen on port 443
ENTRYPOINT ["nginx", "-g", "daemon off;"]

