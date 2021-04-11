ARG BASE_IMAGE
FROM $BASE_IMAGE

RUN pecl install xdebug && \
    f=`find /usr/local/lib/php/extensions/ -name xdebug.so` && \
    echo "zend_extension=$f" >> /usr/local/etc/php/conf.d/pecl-xdebug.ini

# Extending images may use this to configure xdebug based on env variables
COPY xdebug.enable.sh /xdebug.enable.sh
RUN chmod +x /xdebug.enable.sh
