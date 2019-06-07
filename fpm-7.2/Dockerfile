FROM ubuntu:18.04

ARG PHP_VERSION="7.2"
ARG NODE_VERSION="8.16.0"

# Add alternative PHP repository
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common && \
    add-apt-repository -y ppa:ondrej/php

# Install PHP core extensions
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-gmp \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-memcache \
    php${PHP_VERSION}-memcached \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-readline \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-tidy \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-zip \
    # Install PHP SAPI
    php7.3-fpm \
    # Install Gearman tools
    imagemagick \
    jpegoptim \
    librsvg2-bin \
    libimage-exiftool-perl \
    opendkim \
    opendkim-tools \
    # I don't think the "build-tools" should be part of the base image either, but here we go anyways...
    curl \
    git \
    make \
    g++ \
    mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Install Kafka PECL extension
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    librdkafka-dev \
    librdkafka1 \
    php-pear \
    php${PHP_VERSION}-dev && \
    pecl install rdkafka && \
    echo "; configuration for php rdkafka module" > /etc/php/${PHP_VERSION}/mods-available/rdkafka.ini && \
    echo "; priority=20" >> /etc/php/${PHP_VERSION}/mods-available/rdkafka.ini && \
    echo "extension=rdkafka.so" >> /etc/php/${PHP_VERSION}/mods-available/rdkafka.ini && \
    phpenmod rdkafka && \
    apt-get remove --purge -y php-pear php${PHP_VERSION}-dev && \
    rm -rf /var/lib/apt/lists/*

# Install NodeJS
RUN cd /opt && curl https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz | tar xz && \
    ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/bin/node && \
    ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm && \
    # Webpack: work-around for https://github.com/imagemin/mozjpeg-bin/issues/18
    curl "http://ppa.launchpad.net/hiberis/ppa/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.27-1ubuntu1~ppa1_amd64.deb" -o /tmp/libpng12.deb && \
    dpkg -i /tmp/libpng12.deb && \
    rm /tmp/libpng12.deb

# Install xdebug PECL extension
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    librdkafka-dev \
    librdkafka1 \
    php-pear \
    php${PHP_VERSION}-dev && \
    pecl install xdebug && \
    echo "; configuration for php xdebug module" > /etc/php/${PHP_VERSION}/mods-available/xdebug.ini && \
    echo "zend_extension=xdebug.so" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini && \
    apt-get remove --purge -y php-pear php${PHP_VERSION}-dev && \
    rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && cd /etc/php/7.3/fpm \
    && if [ -d php-fpm.d ]; then \
        # for some reason, upstream's php-fpm.conf.default has "include=NONE/etc/php-fpm.d/*.conf"
        sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
        cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
    else \
        # PHP 5.x doesn't use "include=" by default, so we'll create our own simple config that mimics PHP 7+ for consistency
        mkdir php-fpm.d; \
        cp pool.d/www.conf php-fpm.d/www.conf; \
        { \
            echo '[global]'; \
            echo 'include=/etc/php/7.3/fpm/php-fpm.d/*.conf'; \
        } | tee php-fpm.conf; \
    fi \
    && { \
        echo '[global]'; \
        echo 'error_log = /proc/self/fd/2'; \
        echo; echo '; https://github.com/docker-library/php/pull/725#issuecomment-443540114'; echo 'log_limit = 8192'; \
        echo; \
        echo '[www]'; \
        echo '; if we send this to /proc/self/fd/1, it never appears'; \
        echo 'access.log = /proc/self/fd/2'; \
        echo; \
        echo 'clear_env = no'; \
        echo; \
        echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
        echo 'catch_workers_output = yes'; \
        echo 'decorate_workers_output = no'; \
    } | tee php-fpm.d/docker.conf \
    && { \
        echo '[global]'; \
        echo 'daemonize = no'; \
        echo; \
        echo '[www]'; \
        echo 'listen = 9000'; \
} | tee php-fpm.d/zz-docker.conf

STOPSIGNAL SIGQUIT

EXPOSE 9000

CMD ["php-fpm7.3"]
