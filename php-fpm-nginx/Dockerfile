FROM debian:stretch

ARG HTTP_PORT=8080

# Install php, extensions and handy tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      apt-transport-https curl gnupg ca-certificates && \
    { curl https://packages.sury.org/php/apt.gpg | apt-key add - ; } && \
    { echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/deb.sury.org.list ; } && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      php5.6 php5.6-fpm php5.6-curl php5.6-json php5.6-mbstring php5.6-mcrypt \
             php5.6-bcmath php5.6-mysql php5.6-imap php5.6-gd php5.6-xml php5.6-zip \
      php-redis \
      gettext-base \
      unzip \
      rsync \
      git \
      netcat \
      nginx \
      python3 python3-pip python3-setuptools python3-wheel python3-dev && \
    php -r "if (new Redis() == true){ echo \"OK \r\n\"; }" && \
    pip3 install chaperone && \
    ( cd /etc/nginx && \
      sed -i -E 's%^([[:space:]]*listen[^[:digit:]]*)([[:digit:]]+)(.*)%\1'$HTTP_PORT'\3%' sites-available/default \
      ) && \
    chgrp -R 0 /var/lib/nginx /run  && \
    chmod -R g+rwX /var/lib/nginx /run && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# nginx access / error log
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    mkdir -m 1777 -p /run/php && \
    sed -i -e 's/^.*clear_env.*/clear_env = no/' /etc/php/5.6/fpm/pool.d/www.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | \
      php -- --install-dir=/usr/local/bin --filename=composer

# Add chaperone config
ADD chaperone.conf fpm-nginx.processes.conf /etc/chaperone.d/

# Add init script
ADD init.sh /usr/local/bin

ENV HTTP_PORT=$HTTP_PORT \
    ENABLE_NGINX=true \
    ENABLE_PHPFPM=true

EXPOSE $HTTP_PORT

ENTRYPOINT [ "/usr/local/bin/init.sh" ]
