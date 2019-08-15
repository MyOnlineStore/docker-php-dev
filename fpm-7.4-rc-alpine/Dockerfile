FROM php:7.4-rc-fpm-alpine

ARG ICU4C_SRC="https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz"

COPY docker-php-ext-get /usr/local/bin/docker-php-ext-get

    # Install dependencies
RUN chmod u+x /usr/local/bin/docker-php-ext-get \
 && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
    # ext-gd
    freetype-dev libjpeg-turbo-dev libpng-dev zlib-dev libwebp-dev \
    # ext-gmp
    gmp-dev \
    # ext-imagick
    imagemagick-dev libtool \
    # ext-memcached
    libmemcached-dev zlib-dev \
    # ext-pdo_pgsql
    postgresql-dev \
    # ext-rdkafka
    librdkafka-dev \
    # ext-soap
    libxml2-dev \
    # ext-tidy
    tidyhtml-dev \
    # ext-zip
    libzip-dev \
    # Install libicu library
 && curl -L ${ICU4C_SRC} | tar xz -C /tmp \
 && cd /tmp/icu/source \
 && ./runConfigureICU Linux/gcc \
 && make -j$(nproc) install \
 && rm -rf /tmp/icu \
 && cd / \
    # pre-fetch pecl extensions
 && docker-php-source extract \
 && docker-php-ext-get imagick 3.4.4 \
 && docker-php-ext-get memcached 3.1.3 \
 && docker-php-ext-get rdkafka 3.1.0 \
 && docker-php-ext-get redis 4.3.0 \
 && docker-php-ext-get xdebug 2.8.0beta1 \
    # Configure extensions
 && docker-php-ext-configure bcmath \
 && docker-php-ext-configure exif \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-configure gmp \
 && docker-php-ext-configure imagick \
 && docker-php-ext-configure intl \
 && docker-php-ext-configure memcached \
 && docker-php-ext-configure mysqli \
 && docker-php-ext-configure opcache \
 && docker-php-ext-configure pcntl \
 && docker-php-ext-configure pdo_mysql \
 && docker-php-ext-configure pdo_pgsql \
 && docker-php-ext-configure rdkafka \
 && docker-php-ext-configure redis \
 && docker-php-ext-configure soap \
 && docker-php-ext-configure sockets \
    # Tidy 7.0 image workaround
 && if [ "7.4-rc" = "7.0" ]; then sed -i 's/buffio.h/tidybuffio.h/' /usr/src/php/ext/tidy/*.c;fi \
 && docker-php-ext-configure tidy \
 && docker-php-ext-configure xdebug \
 && docker-php-ext-configure zip \
    # Install core extensions
 && docker-php-ext-install -j$(nproc) \
    bcmath \
    exif \
    gd \
    gmp \
    imagick \
    intl \
    memcached \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    pdo_pgsql \
    rdkafka \
    redis \
    soap \
    sockets \
    tidy \
    xdebug \
    zip \
 && docker-php-source delete \
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
    # Disable all extensions by default
 && rm ${PHP_INI_DIR}/conf.d/docker-php-ext-*.ini \
    # Make the production.ini the default settings
 && mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini
