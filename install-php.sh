#!/bin/sh

apk add file re2c freetds freetype icu libintl libldap libjpeg libmcrypt libpng libpq libwebp

TMP="autoconf \
    curl-dev \
    freetds-dev \
    freetype-dev \
    g++ \
    gcc \
    gettext-dev \
    icu-dev \
    jpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    make \
    openldap-dev"

apk add $TMP

# Configure extensions
docker-php-ext-configure gd --with-jpeg-dir=usr/ --with-freetype-dir=usr/ --with-webp-dir=usr/
docker-php-ext-configure ldap --with-libdir=lib/
docker-php-ext-configure pdo_dblib --with-libdir=lib/

docker-php-ext-install \
    curl \
    exif \
    gd \
    gettext \
    intl \
    ldap \
    pdo_dblib \
    pdo_mysql \
    pdo_pgsql \
    xmlrpc \
    zip

# Download trusted certs
mkdir -p /etc/ssl/certs && update-ca-certificates

# Install composer
cd /tmp && php -r "readfile('https://getcomposer.org/installer');" | php && \
   mv composer.phar /usr/bin/composer && \
   chmod +x /usr/bin/composer

RUN pecl install -o -f redis imagick \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis imagick ldap

apk del $TMP
