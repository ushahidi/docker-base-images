FROM php:5.6.36

# PHP_DOCKER_USH_BUILD_SEQ can be incremented to force a rebuild within the
# same minor version
ENV PHP_VERSION=5 \
    PHP_MAJOR_VERSION=5.6 \
    PHP_MINOR_VERSION=5.6.35 \
    PHP_DOCKER_USH_BUILD_SEQ=1

# Install extensions and handy tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng12-dev \
      libmcrypt-dev \
      libc-client2007e-dev \
      libkrb5-dev \
      libcurl4-openssl-dev \
      gettext-base \
      unzip \
      rsync \
      git \
      bison \
      netcat && \
    docker-php-ext-install mcrypt bcmath pdo_mysql mysqli && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
      php -- --install-dir=/usr/local/bin --filename=composer

# Add ci wrapper
ADD ci-wrapper.sh /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/ci-wrapper.sh" ]
