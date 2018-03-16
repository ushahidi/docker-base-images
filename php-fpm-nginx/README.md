# PHP+FPM+nginx image

## In docker hub

[ushahidi/php-ci repository](https://hub.docker.com/r/ushahidi/php-fpm-nginx/)

### Tags:

* php-X.Y
* php-X.Y.Z

## Features

* extra extensions installed: curl, json, mcrypt, bcmath, pdo, pdo_mysql, mysqli, imap, gd

* tools installed: composer

* configuration of nginx and php-fpm via environment variables:
  - `PHP_EXEC_TIME_LIMIT`
  - `PHPFPM_PM_MAX_CHILDREN`
  - `PHPFPM_PM_START_SERVERS`
  - `PHPFPM_PM_MIN_SPARE_SERVERS`
  - `PHPFPM_PM_MAX_SPARE_SERVERS`
  - `PHPFPM_PM_PROCESS_IDLE_TIMEOUT`
  - `PHPFPM_PM_MAX_REQUESTS`
