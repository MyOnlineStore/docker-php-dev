FROM ubuntu:16.04

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
    git
    php \
    php-fpm \
    php-gmp \
    php-tidy \
    php-memcache \
    php-gd \
    php-pdo-mysql \
    php-mysql \
    php-imagick \
    php-curl \
    php-bcmath \
    php-mbstring \
    php-bz2 \
    php-intl \
    php-mcrypt \
    php-memcache \
    php-memcached \
    php-soap \
    php-zip \
    php-dev && \
    apt-get clean && \

    pecl install xdebug && \

    git clone --depth=1 https://github.com/longxinH/xhprof.git /opt/xhprof && \
    cd /opt/xhprof/extension && \
        phpize && \
        /opt/xhprof/extension/configure --with-php-config=$(which php-config); make -j$(nproc) install && \
    echo "extension = xhprof.so" > /etc/php/7.0/mods-available/xhprof.ini && \
    phpenmod xhprof && \

    mkdir /run/php && \

    sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php/7.0/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm7.0", "-F"]
