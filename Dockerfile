# Alpine Linux
FROM alpine:3.9

MAINTAINER "Alexander Sukhoverkhov <naryl.docker@ave.maria.si>"

# s6
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.0.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
	rm /tmp/s6-overlay-amd64.tar.gz

# Configuration files, s6 services etc.
ADD root /

# apache
RUN apk add --update --no-cache apache2 apache2-utils
RUN mkdir -p /run/apache2 /htdocs && chown -R apache:apache /run/apache2 && \
	sed -i 's#^AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf && \
	sed -i 's#^ServerName .*#\nServerName localhost:80#' /etc/apache2/httpd.conf

# php
RUN apk add --update --no-cache php7 \
		php7-mysqli \
		php7-pdo_mysql \
		php7-apache2 \
		php7-session

# mysql (mariadb in Alpine)
RUN addgroup -S mysql && \
	adduser -G mysql -H -D mysql && \
	mkdir -p /run/mysqld /var/lib/mysql && chown mysql:mysql /run/mysqld /var/lib/mysql
RUN apk add --update --no-cache mysql mysql-client mariadb-server-utils mariadb-mytop && \
	rm /etc/my.cnf.d/mariadb-server.cnf
RUN su mysql -c "mysql_install_db --skip-test-db"

# Interactive stuff
#RUN apk add --update --no-cache vim bash htop

# Interfaces
ENTRYPOINT ["/init"]
VOLUME ["/var/www/localhost/htdocs"]
WORKDIR "/var/www/localhost/htdocs"
EXPOSE 80 3306
