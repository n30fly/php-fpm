## Environment variables

| Environment           | Default Value           | Description                                                  |
| --------------------- | ----------------------- | ------------------------------------------------------------ |
| `SKIP_CHOWN`          | <em>(empty)</em>        | Put any value for skip changing files owner on container start |
| `PUID` | `PGID`       | `1000` | `1000`         | Environment variables PUID & PGID allows map the container internal user to user at host machine |
| `PHP_USE_SOCKET`      | <em>(empty)</em>        | Put any value for using socket instead of tcp connection. Socket available by path `/run/php/php-fpm.sock` |
| `PHP_MEMORY_LIMIT`    | `128M`                  |                                                              |
| `PHP_HIDE_ERRORS`     | <em>(empty)</em>        |                                                              |
| `OPCACHE_ENABLED`     | <em>(empty)</em>        |                                                              |
| `XDEBUG_REMOTE_HOST`  | `host.docker.internal`  |                                                              |
| `XDEBUG_ENABLED`      | <em>(empty)</em>        |                                                              |
| `SMTP_DEFAULT_FROM`   | `no-reply@docker.local` |                                                              |
| `SMTP_HOST`           | `mailcatcher`           |                                                              |
| `SMTP_PORT`           | `1025`                  |                                                              |
| `SMTP_EHLO_DOMAIN`    | <em>(empty)</em>        |                                                              |
| `SMTP_USERNAME`       | <em>(empty)</em>        |                                                              |
| `SMTP_PASSWORD`       | <em>(empty)</em>        |                                                              |
| `SMTP_TLS_CERT_CHECK` | `on`                    |                                                              |


