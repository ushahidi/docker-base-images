FROM php:5.6.31-fpm

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
      netcat \
      nginx \
      supervisor && \
    docker-php-ext-install curl json mcrypt bcmath pdo pdo_mysql mysqli && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# nginx access / error log
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
      php -- --install-dir=/usr/local/bin --filename=composer

# Add supervisor config
ADD programs.conf /etc/supervisor/conf.d/programs.conf

# Add startup script
ADD startup.sh /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
