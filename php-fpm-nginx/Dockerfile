FROM php:5.6.31-fpm

ARG HTTP_PORT=8080

# Install extensions and handy tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
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
      python3-pip \
      python3-dev && \
    pip3 install chaperone && \
    ( cd /etc/nginx && \
      sed -i -E 's%^([[:space:]]*listen[^[:digit:]]*)([[:digit:]]+)(.*)%\1'$HTTP_PORT'\3%' sites-available/default \
      ) && \
    chgrp -R 0 /var/lib/nginx /run && \
    chmod -R g+rwX /var/lib/nginx /run && \
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

# Add chaperone config
ADD fpm-nginx.processes.conf /etc/chaperone.d/

# Add init script
ADD init.sh /usr/local/bin

ENV HTTP_PORT=$HTTP_PORT \
    ENABLE_NGINX=true \
    ENABLE_PHPFPM=true

EXPOSE $HTTP_PORT

ENTRYPOINT [ "/usr/local/bin/init.sh" ]
