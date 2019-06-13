FROM php:7.2-fpm-alpine

    # Install dependencies
RUN apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
    # ext-gd
    freetype-dev libjpeg-turbo-dev libpng-dev zlib-dev libwebp-dev \
    # ext-gmp
    gmp-dev \
    # ext-imagick
    imagemagick-dev libtool \
    # ext-intl
    icu-dev \
    # ext-memcached
    libmemcached-dev zlib-dev \
    # ext-rdkafka
    librdkafka-dev \
    # ext-tidy
    tidyhtml-dev \
    # ext-zip
    libzip-dev \
    # Configure extensions
 && docker-php-ext-configure bcmath \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-configure gmp \
 && docker-php-ext-configure intl \
 && docker-php-ext-configure mysqli \
 && docker-php-ext-configure opcache \
 && docker-php-ext-configure pcntl \
 && docker-php-ext-configure pdo_mysql \
 && docker-php-ext-configure sockets \
 && docker-php-ext-configure tidy \
 && docker-php-ext-configure zip \
    # Install core extensions
 && docker-php-ext-install -j$(nproc) \
    bcmath \
    gd \
    gmp \
    intl \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    sockets \
    tidy \
    zip \
    # Install pecl extensions
 && pecl install imagick \
 && pecl install memcached \
 && pecl install rdkafka \
 && pecl install redis \
 && pecl install xdebug \
    # Install/Keep runtime dependencies
 && apk add --no-cache \
    $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    ) \
    # Remove build dependencies
 && apk del --no-network .build-deps \
    # Remove PECL leftovers
 && rm -rf /tmp/pear ~/.pearrc
    # Disable all extensions by default
 && rm ${PHP_INI_DIR}/conf.d/docker-php-ext-*.ini \
    # Make the production.ini the default settings
 && mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini \
