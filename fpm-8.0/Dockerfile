FROM php:8.0-fpm

ARG ICU4C_SRC="https://github.com/unicode-org/icu/releases/download/release-68-2/icu4c-68_2-src.tgz"

COPY docker-php-ext-get /usr/local/bin/docker-php-ext-get

# Install dependencies
RUN chmod u+x /usr/local/bin/docker-php-ext-get \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${PHPIZE_DEPS} \
    # ca-certifcates are used for outbound TLS connections by curl implementations
    ca-certificates \
    # ext-gd
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev zlib1g-dev libwebp-dev \
    # ext-gmp
    libgmp-dev \
    # ext-imagick
    libmagickwand-dev \
    # ext-pdo_pgsql
    libpq-dev \
    # ext-soap
    libxml2-dev \
    # ext-tidy
    libtidy-dev \
    # ext-zip
    libzip-dev \
    # libfcgi-bin is used for cgi-fcgi healthcheck in k8s containers
    libfcgi-bin \
    # librdkafka
    libssl-dev \
    # Install supercronic
 && curl -fsSLO "https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64" \
 && echo "048b95b48b708983effb2e5c935a1ef8483d9e3e  supercronic-linux-amd64" | sha1sum -c - \
 && chmod +x "supercronic-linux-amd64" \
 && mv "supercronic-linux-amd64" "/usr/local/bin/supercronic-linux-amd64" \
 && ln -s "/usr/local/bin/supercronic-linux-amd64" /usr/local/bin/supercronic \
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
 && if [ "8.0" != "8.0" ]; then docker-php-ext-get imagick 3.4.4 ;fi \
 && docker-php-ext-get pcov 1.0.6 \
 && docker-php-ext-get rdkafka 5.0.0 \
 && docker-php-ext-get redis 5.3.3 \
 && docker-php-ext-get xdebug 3.0.3 \
    # Configure extensions
 && docker-php-ext-configure bcmath \
 && docker-php-ext-configure exif \
 && docker-php-ext-configure gd `if [ "8.0" = "7.4" ] || [ "8.0" = "8.0" ]; then echo "--with-freetype --with-jpeg"; else echo "--with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/";fi` \
 && docker-php-ext-configure gmp \
 && if [ "8.0" != "8.0" ]; then docker-php-ext-configure imagick ;fi \
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
 && if [ "8.0" != "8.0" ]; then docker-php-ext-install imagick ;fi \
 && docker-php-source delete \
    # Install/Keep runtime dependencies
    # libfcgi-bin is used for cgi-fcgi healthcheck in k8s containers
    # ca-certifcates is used for outbound TLS connections by curl implementations
 && apt-mark auto '.*' > /dev/null \
 && find /usr/local -type f -executable -exec ldd '{}' ';' \
    | awk '/=>/ { print $(NF-1) }' \
    | sort -u \
    | xargs -r dpkg-query --search \
    | cut -d: -f1 \
    | sort -u \
    | xargs -r apt-mark manual \
 && apt-mark manual libc6 binutils libfcgi-bin ca-certificates \
    # Remove build dependencies
 && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    # Disable all extensions by default
 && rm ${PHP_INI_DIR}/conf.d/docker-php-ext-*.ini \
    # Make the production.ini the default settings
 && mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini

