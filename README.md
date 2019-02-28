naryl/lamp
==========

This Docker image is a minimalistic lamp server based on Alpine Linux.
Intended use is to mount a local directory containing a simple PHP project and
have the container serve it over HTTP. This readme assumes that you may have a
real LAMP stack installed and avoids using default ports.

Note that none of the services inside are secured so this image is not intended
to be exposed to Internets.

Includes the following components:

 * Alpine Linux 3.9
 * Apache HTTP Server 2.4
 * MariaDB 10.3
 * PHP 7.2
 * PHP modules
	* php7-apache2
	* php7-common
	* php7-mysqli
	* php7-mysqlnd
	* php7-openssl
	* php7-pdo
	* php7-pdo_mysql
	* php7-session

The image only includes PHP modules needed to interface with MySQL but it's simple to add more:

```
FROM naryl/lamp:latest

RUN apk add --no-cache --update php7-json php7-xml
```

Installation from [Docker registry hub](https://registry.hub.docker.com/u/naryl/lamp/).
----

You can download the image using the following command:

```bash
docker pull naryl/lamp
```

Exposed port and volumes
----

The image exposes ports `80` and `3306`, and one volume:

* `/var/www/localhost/htdocs` - apache's DocumentRoot

Use cases
----

#### Create a container running a local directory as PHP web app:

```
	docker run -d -p 8080:80 -v /path/to/app:/var/www/localhost/htdocs naryl/lamp
```

#### Open a MariaDB console inside a container

```
	docker run -d -p 8080:80 -p 3307:3306 -v /path/to/app:/var/www/localhost/htdocs naryl/lamp
	mysql -P 3307
```
