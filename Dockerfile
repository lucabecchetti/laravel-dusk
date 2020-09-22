FROM jenkins/jnlp-slave:alpine as jnlp

# Build app image
FROM php:apache
LABEL maintainer="Luca Becchetti <https://www.brokenice.it>"

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  libonig-dev \
  libmagickwand-dev \
  zlib1g-dev \
  libldap2-dev \
  ldap-utils \
  ldap-utils \
  zlib1g-dev \
  libzip-dev \
  git \
  libpng-dev \
  curl \
  m4 \
  autoconf \
  libtool \
  libcurl3-dev \
  libssl-dev \
  unzip \
&& rm -r /var/lib/apt/lists/*

RUN pecl install -o -f redis imagick && rm -rf /tmp/pear

RUN docker-php-ext-enable \
    redis \
    imagick

RUN docker-php-ext-install \
    mbstring \
    opcache \
    pdo_mysql \
    ldap \
    pcntl \
    zip \
    gd \
    curl

# pecl_http
RUN pecl install propro && \
    docker-php-ext-enable propro && \
    pecl install raphf && \
    docker-php-ext-enable raphf && \
    pecl install pecl_http && \
    echo "extension=http.so" >> /usr/local/etc/php/conf.d/docker-php-ext-http.ini

ADD install-composer.sh /usr/sbin/install-composer.sh
RUN /usr/sbin/install-composer.sh

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/slave.jar /usr/share/jenkins/slave.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
