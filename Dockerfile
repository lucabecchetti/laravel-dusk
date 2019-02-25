FROM php:alpine
LABEL maintainer="Becchetti Luca <luca.becchetti@gmail.com>"

# Comment this to improve stability on "auto deploy" environments
RUN apk update && apk upgrade

#------------ Needs to install php-amqp ------------
# trust this project public key to trust the packages.
ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
# make sure you can use HTTPS
RUN apk --update add ca-certificates
RUN echo "@php https://php.codecasts.rocks/v3.8/php-7.2" >> /etc/apk/repositories
RUN apk add --update php-amqp@php
#------------ Needs to install php-amqp ------------

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
		php \
		php7-apache2 \
        php7-gd \
		php7-zip \
		php7-pdo_mysql \
		php7-curl \
        php7-mcrypt \
		php7-mbstring \
		php7-dom \
		php7-json \
    	php7-phar \
		php7-tokenizer \
		php7-session \
		php7-fileinfo \
		php7-bcmath \
		php-amqp \
		php7-sockets \
    && apk add --no-cache --virtual \
		.build-deps \
		openssh-client \
		git \
		npm \
		bash \
        lcms2-dev \
		libpng-dev \
		gcc \
		g++ \
		make \
		autoconf \
		automake \
		openrc

# Install PHP extensions
ADD install-php.sh /usr/sbin/install-php.sh
RUN /usr/sbin/install-php.sh

# Install composer
RUN cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
    mv composer.phar /usr/bin/composer && \
    chmod +x /usr/bin/composer

# Install PHPUnit
RUN curl -sSL -o /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit

# Install PHP extensions
ADD install-node.sh /usr/sbin/install-node.sh
RUN chmod a+x /usr/sbin/install-node.sh
RUN /usr/sbin/install-node.sh

# Install chromedriver
RUN apk add --no-cache chromium chromium-chromedriver

# Start chromedriver
RUN chromedriver &

WORKDIR /var/www
CMD php ./artisan serve --port=80 --host=0.0.0.0 --env=dusk.local
EXPOSE 80
EXPOSE 9515
HEALTHCHECK --interval=1m CMD curl -f http://localhost/ || exit 1
