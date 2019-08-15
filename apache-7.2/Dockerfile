FROM ubuntu:18.04

ARG PHP_VERSION="7.2"
ARG NODE_VERSION="8.16.0"

ENV APACHE_RUN_DIR="/var/run/apache2"
ENV APACHE_PID_FILE="${APACHE_RUN_DIR}/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

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
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-readline \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-tidy \
    php${PHP_VERSION}-tokenizer \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-zip \
    # Install PHP SAPI
    ca-certificates \
    apache2 \
    libapache2-mod-php${PHP_VERSION} \
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

COPY configs/* /etc/apache2/conf-available/
COPY mods/* /etc/apache2/mods-available/

RUN a2dismod access_compat && \
    a2dissite default-ssl && \
    a2disconf other-vhosts-access-log serve-cgi-bin && \
    a2enmod headers mpm_prefork ssl && \
    a2enconf security symfony logs

WORKDIR /srv/app

EXPOSE 80

CMD ["apache2", "-DFOREGROUND"]
