FROM php:7.2-rc-fpm

ENV LIBICU_TAG="release-55-1" \
    NODE_VERSION="8.9.1"

RUN set -xe && \
    requiredDeps=" \
        # ext-gd \
        libpng-dev libjpeg62-turbo-dev libfreetype6-dev zlib1g-dev libwebp-dev \
        # ext-mcrypt \
        libmcrypt-dev \
        # ext-tidy \
        libtidy-dev \
        # ext-xsl \
        libxslt1-dev \
        # ext-soap ext-wddx ext-xmlrpc \
        libxml2-dev \
        # ext-imap
        libc-client2007e \
    " && \
    buildDeps=" \
        git \
        subversion \
        # ext-bz2 \
        libbz2-dev \
        # ext-enchant \
        #libenchant-dev \
        # ext-gmp \
        libgmp3-dev \
        # ext-imap \
        libc-client-dev libkrb5-dev \
        # ext-interbase ext-pdo_firebird
        #firebird-dev \
        # ext-intl, outdated \
        #libicu-dev \
        # ext-ldap \
        #libldap2-dev \
        # ext-pdo_dblib \
        #freetds-dev \
        # ext-oci8 ext-pdo_oci \
        #libaio-dev \
        # ext-pdo_odbc \
        #unixodbc-dev \
        # ext-pdo_pgsql \
        #libpq-dev postgresql-server-dev-all \
        # ext-pspell \
        #libpspell-dev \
        # ext-recode \
        #librecode-dev \
        # pecl-memcached \
        libmemcached-dev zlib1g-dev \
        # pecl-imagick \
        libmagickwand-dev \
    " && \

    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install $buildDeps $requiredDeps nullmailer --no-install-recommends && \

    ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/ && \

    # ext-intl
    svn export --non-interactive http://source.icu-project.org/repos/icu/icu/tags/${LIBICU_TAG} /tmp/libicu && \
    cd /tmp/libicu/source && \
    ./runConfigureICU Linux/gcc && \
    make -j$(nproc) install && \

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
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
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
        imap \
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

    git clone --depth=1 https://github.com/websupport-sk/pecl-memcache.git /tmp/memcache && \
    cd /tmp/memcache && \
        phpize && \
        /tmp/memcache/configure --with-php-config=$(which php-config); make -j$(nproc) install && \
    docker-php-ext-enable memcache && \

    docker-php-source delete && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps && \
    pecl update-channels && \
    apt-get clean && \
    rm -rf /tmp/pear ~/.pearrc /tmp/libicu /var/lib/apt/lists/* /tmp/memcache && \

    # this shouldn't be included in the base image, but as the legacy implementation lives on there was no other option
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        mysql-client \
        git \
        imagemagick \
        jpegoptim \
        librsvg2-bin \
        libimage-exiftool-perl \
        opendkim \
        opendkim-tools \
        supervisor && \

    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* && \

    cd /opt && curl https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz | tar xz && \
    ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/bin/node && \
    ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm
