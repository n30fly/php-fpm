#!/usr/bin/env bash

if [ ! -z "$PUID" ]; then
  if [ -z "$PGID" ]; then
    PGID=${PUID}
  fi
  usermod -u $PUID www-data
  groupmod -g $PGID www-data
  if [ -z "$SKIP_CHOWN" ]; then
    chown -Rf www-data:www-data /var/www/html
  fi
fi
