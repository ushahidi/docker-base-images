ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN apt update && \
    apt install php${PHP_MAJOR_VERSION}-xdebug && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY xdebug.enable.sh /entrypoint.xdebug.enable.sh
RUN $DOCKERCES_MANAGE_UTIL add /entrypoint.xdebug.enable.sh
