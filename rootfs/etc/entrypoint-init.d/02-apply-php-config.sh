#!/usr/bin/env bash

echo "" > /usr/local/etc/php/conf.d/custom.ini

if [ ! -z "$PHP_USE_SOCKET" ]; then
    mkdir -p /run/php
    chown www-data:www-data /run/php
    sed -i 's/listen = 9000/listen = \/run\/php\/php-fpm.sock/g' /usr/local/etc/php-fpm.d/zz-docker.conf
    sed -r -i '/;listen\.(owner|group|mode)/s/^;//g' /usr/local/etc/php-fpm.d/www.conf
    sed -i 's/listen.mode = 0660/listen.mode = 0666/g' /usr/local/etc/php-fpm.d/www.conf
    sed -r -i '/;clear_env/s/^;//g' /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$PHP_MEMORY_LIMIT" ]; then
    echo "memory_limit=$PHP_MEMORY_LIMIT" >> /usr/local/etc/php/conf.d/custom.ini
fi

if [ ! -z "$PHP_HIDE_ERRORS" ]; then
  { \
    echo 'error_reporting = E_ERROR | E_WARNING | E_PARSE | E_CORE_ERROR | E_CORE_WARNING | E_COMPILE_ERROR | E_COMPILE_WARNING | E_RECOVERABLE_ERROR'; \
    echo 'display_errors = Off'; \
    echo 'display_startup_errors = Off'; \
    echo 'html_errors = Off'; \
  } > /usr/local/etc/php/conf.d/error-logging.ini
fi

if [ ! -z "$OPCACHE_ENABLED" ]; then
  { \
    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name opcache.so)"; \
    echo 'opcache.enable=1'; \
    echo 'opcache.enable_cli=0'; \
    echo 'opcache.save_comments=1'; \
    echo 'opcache.memory_consumption=256'; \
    echo 'opcache.interned_strings_buffer=128'; \
    echo 'opcache.max_accelerated_files=130987'; \
    echo 'opcache.validate_timestamps=1'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
  } > /usr/local/etc/php/conf.d/opcache.ini
else
  echo "" > /usr/local/etc/php/conf.d/opcache.ini
fi

REMOTE_HOST="host.docker.internal"
if [ ! -z "$XDEBUG_REMOTE_HOST" ]; then
  REMOTE_HOST="$XDEBUG_REMOTE_HOST"
fi

if [ ! -z "$XDEBUG_ENABLED" ]; then
  PHP_VERSION=$(php -r "echo version_compare(PHP_VERSION, '8.0.0') >= 0 ? '8' : '7';")

  XDEBUG_MODE="xdebug.remote_enable=on"
  XDEBUG_HOST="xdebug.remote_host=$REMOTE_HOST"
  XDEBUG_PORT="xdebug.remote_port=9000"
  XDEBUG_DISCOVER="xdebug.remote_connect_back=0"

  if [ "$PHP_VERSION" -eq "8" ]; then
    XDEBUG_MODE="xdebug.mode=debug"
    XDEBUG_HOST="xdebug.client_host=$REMOTE_HOST"
    XDEBUG_PORT="xdebug.client_port=9000"
    XDEBUG_DISCOVER="xdebug.discover_client_host=0"
  fi

  { \
    echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)"; \
    echo "$XDEBUG_MODE"; \
    echo "$XDEBUG_HOST"; \
    echo "$XDEBUG_PORT"; \
    echo "xdebug.remote_autostart=off"; \
    echo "xdebug.start_with_request=yes"; \
    echo "xdebug.max_nesting_level=9999"; \
    echo "$XDEBUG_DISCOVER"; \
    echo "xdebug.idekey=PHPSTORM"; \
  } > /usr/local/etc/php/conf.d/xdebug-enabled.ini

  ping -c1 host.docker.internal && :
  if [ $? -ne 0 ]; then
    /sbin/ip -4 route list match 0/0 | awk '{print $3" host.docker.internal"}' >> /etc/hosts
  fi
else
    echo "" > /usr/local/etc/php/conf.d/xdebug-enabled.ini
fi

