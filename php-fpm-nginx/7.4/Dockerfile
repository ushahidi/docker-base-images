FROM ushahidi/debian:bullseye-dockerize

# PHP_DOCKER_USH_BUILD_SEQ can be incremented to force a rebuild within the
# same minor version
ENV PHP_VERSION=7 \
    PHP_MAJOR_VERSION=7.4 \
    PHP_MINOR_VERSION=7.4.33 \
    PHP_DOCKER_USH_BUILD_SEQ=1

# Install php, extensions and handy tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      lsb-release apt-transport-https curl ca-certificates && \
    { curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb ; dpkg -i /tmp/debsuryorg-archive-keyring.deb ; rm /tmp/debsuryorg-archive-keyring.deb; } && \
    { echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/deb.sury.org.list ; } && \
    apt-get update && \
    PHP_PKG_VERSION=$(apt-cache show php${PHP_MAJOR_VERSION} | grep -E "^Version: ([[:digit:]]+:)?${PHP_MINOR_VERSION}" | sed -E -e 's/^Version:\s*//' | sort -r | head -1) && \
    apt-get install -y --no-install-recommends \
      php7.4=${PHP_PKG_VERSION} \
        php7.4-fpm php7.4-curl php7.4-json php7.4-mbstring \
        php7.4-bcmath php7.4-mysql php7.4-imap php7.4-gd php7.4-xml php7.4-zip \
        php7.4-redis php7.4-memcached \
      gettext-base \
      unzip \
      rsync \
      git \
      netcat \
      nginx \
      python3 python3-pip python3-setuptools python3-wheel python3-dev && \
    php -r "if (new Redis() == true){ echo \"OK \r\n\"; }" && \
    pip3 install chaperone && \
    pip3 install 'PyYAML>=3.1.1,<5.4' && \
    test -d /usr/local/lib/python3.9/dist-packages/chaperone && \
    grep -lr 'asyncio.async' /usr/local/lib/python3.9/dist-packages/chaperone | \
      xargs sed -i -e 's/asyncio\.async/asyncio.ensure_future/' && \
    chgrp -R 0 /var/lib/nginx /run  && \
    chmod -R g+rwX /var/lib/nginx /run && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# nginx access / error log , php-fpm tweaking
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
ADD php-fpm.conf ${DOCKERIZE_TEMPLATE_DIR}/etc/php/${PHP_MAJOR_VERSION}/fpm/php-fpm.conf
ADD php-ush.ini ${DOCKERIZE_TEMPLATE_DIR}/etc/php/${PHP_MAJOR_VERSION}/fpm/conf.d/99-ush.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
      php -- --2 --install-dir=/usr/local/bin --filename=composer

# Add nginx config template
ADD nginx-vhost.conf ${DOCKERIZE_TEMPLATE_DIR}/etc/nginx/sites-available/default

# Add chaperone config
ADD chaperone.conf fpm-nginx.processes.conf /etc/chaperone.d/

# Add init script as endpoint of the container image
ADD init.sh /usr/local/bin
RUN $DOCKERCES_MANAGE_UTIL endpoint /usr/local/bin/init.sh

ENV HTTP_PORT=8080 \
    ENABLE_NGINX=true \
    ENABLE_PHPFPM=true \
    PHP_EXEC_TIME_LIMIT=900

EXPOSE $HTTP_PORT
