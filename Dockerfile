FROM php:7.0-fpm

RUN apt-get -q update && DEBIAN_FRONTEND=noninteractive apt-get -qy install \
        git \
        # ext-bz2
        libbz2-dev \
        # ext-enchant
        #libenchant-dev \
        # ext-gd
        libpng12-dev libjpeg62-turbo-dev libfreetype6-dev zlib1g-dev libwebp-dev \
        # ext-gmp
        libgmp3-dev \
        # ext-imap
        #libc-client-dev libkrb5-dev \
        # ext-interbase ext-pdo_firebird
        #firebird-dev \
        # ext-intl
        libicu-dev \
        # ext-ldap
        #libldap2-dev \
        # ext-mcrypt
        libmcrypt-dev \
        # ext-pdo_dblib
        #freetds-dev \
        # ext-oci8 ext-pdo_oci
        #libaio-dev \
        # ext-pdo_odbc
        #unixodbc-dev \
        # ext-pdo_pgsql
        #libpq-dev postgresql-server-dev-all \
        # ext-pspell
        #libpspell-dev \
        # ext-recode
        #librecode-dev \
        # ext-soap ext-wddx ext-xmlrpc
        libxml2-dev \
        # ext-tidy
        libtidy-dev \
        # ext-xsl
        libxslt1-dev \
        # pecl-memcached
        libmemcached-dev zlib1g-dev \
        # pecl-imagick
        libmagickwand-dev && \

    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/ && \

    docker-php-ext-configure bcmath && \
    docker-php-ext-configure bz2 && \
    docker-php-ext-configure calendar && \
    docker-php-ext-configure ctype && \
    docker-php-ext-configure exif && \
    docker-php-ext-configure gettext && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-png-dir=/usr/include \
        --with-webp-dir=/usr/include && \
    docker-php-ext-configure gmp && \
    docker-php-ext-configure intl && \
    docker-php-ext-configure json && \
    docker-php-ext-configure mcrypt && \
    docker-php-ext-configure mysqli && \
    docker-php-ext-configure opcache && \
    docker-php-ext-configure pcntl && \
    docker-php-ext-configure pdo && \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-configure shmop && \
    docker-php-ext-configure soap && \
    docker-php-ext-configure sockets && \
    docker-php-ext-configure sysvmsg && \
    docker-php-ext-configure sysvsem && \
    docker-php-ext-configure sysvshm && \
    docker-php-ext-configure tidy && \
    docker-php-ext-configure wddx && \
    docker-php-ext-configure xsl && \
    docker-php-ext-configure zip && \

    docker-php-ext-install -j$(nproc) \
        bcmath \
        bz2 \
        calendar \
        ctype \
        exif \
        gd \
        gmp \
        gettext \
        intl \
        json \
        mcrypt \
        mysqli \
        opcache \
        pcntl \
        pdo \
        pdo_mysql \
        shmop \
        soap \
        sockets \
        sysvmsg \
        sysvsem \
        sysvshm \
        tidy \
        wddx \
        xsl \
        zip && \

    pecl install xdebug && \
    pecl install memcached && \
    pecl install imagick && \
    docker-php-ext-enable \
        xdebug \
        memcached \
        imagick && \

    git clone --depth=1 https://github.com/longxinH/xhprof.git /opt/xhprof && \
    cd /opt/xhprof/extension && \
        phpize && \
        /opt/xhprof/extension/configure --with-php-config=$(which php-config); make -j$(nproc) install && \
    docker-php-ext-enable xhprof
