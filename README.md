![Docker Pulls](https://img.shields.io/docker/pulls/hitalos/php.svg)

# LARAVEL DUSK DOCKER
Docker image to run basic laravel projects and dusk tests

This image it's for development. **Optimize to use in production!**

## Versions
* `php` 7.2.12
  * `composer` 1.7.3
  * `phpunit` 7.4.3

## Supported Databases (**PDO**)
* `mssql` (via dblib)
* `mysql`
* `pgsql`
* `sqlite`

## Extra supported extensions
* `curl`
* `exif`
* `gd`
* `ldap`
* `mongodb`

## Installing
    docker pull brokenice/laravel-jenkins

## Using

### With `docker`
    docker run --name <container_name> -d -v $PWD:/var/www -p 80:80 brokenice/laravel-jenkins
Where $PWD is the project folder.

### With `docker-compose`

Create a `docker-compose.yml` file in the root folder of project using this as a template:
```
web:
    image: brokenice/laravel-jenkins:latest
    ports:
        - 80:80
    volumes:
        - ./:/var/www
    command: php -S 0.0.0.0:80 -t public public/index.php
```

Then run using this command:

    docker-compose up