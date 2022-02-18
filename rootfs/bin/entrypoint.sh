#!/usr/bin/env bash
set -e

# Run startup scripts
run-parts --regex '.*sh$' /etc/entrypoint-init.d

if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

exec "$@"
