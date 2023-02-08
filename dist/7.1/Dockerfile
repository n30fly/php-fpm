FROM php:7.1.33-fpm-alpine

ARG PHPREDIS_VERSION=5.1.1
ARG JQ_VERSION=1.6
ARG XDEBUG_VERSION=2.9.2
ARG MCRYPT_VERSION=1.0.4

ARG PHPIZE_DEPS \
    autoconf \
    dpkg-dev dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    pkgconf \
    re2c

ENV PUID=1000 \
    GUID=1000 \
    SKIP_CHOWN="" \

    PHP_USE_SOCKET="" \
    PHP_MEMORY_LIMIT="128M" \
    XDEBUG_ENABLED="" \
    OPCACHE_ENABLED="" \
    PHP_HIDE_ERRORS="" \

    SMTP_HOST="mailcatcher" \
    SMTP_PORT="1025" \
    SMTP_USERNAME="" \
    SMTP_PASSWORD="" \
    SMTP_EHLO_DOMAIN="" \
    SMTP_DEFAULT_FROM="no-reply@docker.local" \
    SMTP_TLS_CERT_CHECK="on"

ENTRYPOINT ["/bin/entrypoint.sh"]

RUN apk upgrade --update --no-cache \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        libxml2-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        bzip2-dev \
        zlib-dev \
        libzip-dev \
        libcurl \
        libmcrypt-dev \
        oniguruma-dev \
        libxslt-dev \
        icu-dev \
    && apk add --no-cache \
        run-parts \
        zip \
        git \
        openssh-client \
        bash \
        gnupg \
        procps \
        curl \
        zlib \
        make \
        shadow \
        msmtp \
        patch \
    && pecl install -o -f mcrypt-${MCRYPT_VERSION} xdebug-${XDEBUG_VERSION} igbinary \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd sockets pdo_mysql mysqli pcntl zip intl xsl soap bcmath \
    && docker-php-ext-enable mcrypt igbinary \
    && mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && docker-php-ext-install redis \
    && docker-php-source delete; \
        runDeps="$( \
            scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
                | tr ',' '\n' \
                | sort -u \
                | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        )"; \
        apk add --no-cache $runDeps; \
        apk del --no-network .build-deps \
    && rm -rf /var/cache/apk/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && curl -s -L -o /tmp/jq-release.key https://raw.githubusercontent.com/stedolan/jq/master/sig/jq-release.key \
    && curl -s -L -o /tmp/jq-linux64.asc https://raw.githubusercontent.com/stedolan/jq/master/sig/v${JQ_VERSION}/jq-linux64.asc \
    && curl -s -L -o /tmp/jq-linux64 https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 \
    && gpg --import /tmp/jq-release.key \
    && gpg --verify /tmp/jq-linux64.asc /tmp/jq-linux64 \
    && cp /tmp/jq-linux64 /usr/bin/jq \
    && chmod +x /usr/bin/jq \
    && rm -f /tmp/jq-release.key \
    && rm -f /tmp/jq-linux64.asc \
    && rm -f /tmp/jq-linux64 \
    && rm -rf /root/.composer

COPY rootfs /

CMD [ "/usr/local/sbin/php-fpm" ]
