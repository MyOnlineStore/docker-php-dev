FROM php:7.2-fpm-alpine

ARG ICU4C_SRC="https://github.com/unicode-org/icu/releases/download/release-64-2/icu4c-64_2-src.tgz"

COPY docker-php-ext-get /usr/local/bin/docker-php-ext-get

# Build dependencies
RUN chmod u+x /usr/local/bin/docker-php-ext-get \
 && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} \
    # ext-gd
    freetype-dev libjpeg-turbo-dev libpng-dev zlib-dev libwebp-dev \
    # ext-gmp
    gmp-dev \
    # ext-imagick
    imagemagick-dev libtool \
    # ext-pdo_pgsql
    postgresql-dev \
    # ext-soap
    libxml2-dev \
    # ext-tidy
    tidyhtml-dev \
    # ext-zip
    libzip-dev \
    # librdkafka
    openssl-dev \
    # Install libicu library
 && curl -L ${ICU4C_SRC} | tar xz -C /tmp \
 && cd /tmp/icu/source \
 && ./runConfigureICU Linux/gcc \
 && make -j$(nproc) install \
 && rm -rf /tmp/icu \
    # Add librdkafka library
 && mkdir -p /tmp/librdkafka \
 && cd /tmp/librdkafka \
 && curl -L https://github.com/edenhill/librdkafka/archive/v1.6.0.tar.gz | tar xz --strip-components=1 \
 && ./configure && make && make install \
 && rm -rf /tmp/librdkafka \
    # pre-fetch pecl extensions
 && cd / \
 && docker-php-source extract \
 && if [ "7.2" != "8.0" ]; then echo docker-php-ext-get imagick 3.4.4 ;fi \
 && docker-php-ext-get pcov 1.0.6 \
 && docker-php-ext-get rdkafka 5.0.0 \
 && docker-php-ext-get redis 5.3.3 \
 && docker-php-ext-get xdebug 3.0.3 \
    # Configure extensions
 && docker-php-ext-configure bcmath \
 && docker-php-ext-configure exif \
 && docker-php-ext-configure gd `if [ "7.2" = "7.4" ] || [ "7.2" = "8.0" ]; then echo "--with-freetype --with-jpeg"; else echo "--with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/";fi` \
 && docker-php-ext-configure gmp \
 && if [ "7.2" != "8.0" ]; then echo docker-php-ext-configure imagick ;fi \
 && docker-php-ext-configure intl \
 && docker-php-ext-configure mysqli \
 && docker-php-ext-configure opcache \
 && docker-php-ext-configure pcntl \
 && docker-php-ext-configure pcov \
 && docker-php-ext-configure pdo_mysql \
 && docker-php-ext-configure pdo_pgsql \
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
    intl \
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
 && if [ "7.2" != "8.0" ]; then echo docker-php-ext-install imagick ;fi \
 && docker-php-source delete \
    # Install/Keep runtime dependencies
    # fcgi is used for cgi-fcgi healthcheck in k8s containers
    # ca-certifcates is used for outbound TLS connections by curl implementations
 && apk add --no-cache \
    $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    ) \
    fcgi \
    ca-certificates \
    # Remove build dependencies
 && apk del --no-network .build-deps \
    # Disable all extensions by default
 && rm ${PHP_INI_DIR}/conf.d/docker-php-ext-*.ini \
    # Make the production.ini the default settings
 && mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini
