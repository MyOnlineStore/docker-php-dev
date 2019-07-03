FROM php:7.2-fpm

ARG ICU4C_SRC="https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz"

COPY docker-php-ext-get /usr/local/bin/docker-php-ext-get

    # Install dependencies
RUN chmod u+x /usr/local/bin/docker-php-ext-get \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${PHPIZE_DEPS} \
    # ext-gd
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev zlib1g-dev libwebp-dev \
    # ext-gmp
    libgmp-dev \
    # ext-imagick
    libmagickwand-dev \
    # ext-memcached
    libmemcached-dev zlib1g-dev \
    # ext-rdkafka
    librdkafka-dev \
    # ext-soap
    libxml2-dev \
    # ext-tidy
    libtidy-dev \
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
 && docker-php-ext-get xdebug 2.7.2 \
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
 && docker-php-ext-configure rdkafka \
 && docker-php-ext-configure redis \
 && docker-php-ext-configure soap \
 && docker-php-ext-configure sockets \
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
    rdkafka \
    redis \
    soap \
    sockets \
    tidy \
    xdebug \
    zip \
 && docker-php-source delete \
    # Install/Keep runtime dependencies
 && apt-mark auto '.*' > /dev/null \
 && find /usr/local -type f -executable -exec ldd '{}' ';' \
    | awk '/=>/ { print $(NF-1) }' \
    | sort -u \
    | xargs -r dpkg-query --search \
    | cut -d: -f1 \
    | sort -u \
    | xargs -r apt-mark manual \
 && apt-mark manual librdkafka1 libmemcached11 libmemcachedutil2 libmagickwand-6.q16-3 libc6 binutils \
    # Remove build dependencies
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    # Disable all extensions by default
 && rm ${PHP_INI_DIR}/conf.d/docker-php-ext-*.ini \
    # Make the production.ini the default settings
 && mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini
