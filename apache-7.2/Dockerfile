FROM ubuntu:18.04

ENV APACHE_RUN_DIR="/var/run/apache2"
ENV APACHE_PID_FILE="${APACHE_RUN_DIR}/apache2.pid"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"
ENV NODE_VERSION="8.15.1"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates \
      apache2 \
      libapache2-mod-php \
      php-bcmath \
      php-bz2 \
      php-curl \
      php-gd \
      php-gmp \
      php-imagick \
      php-imap \
      php-intl \
      php-json \
      php-mbstring \
      php-memcache \
      php-memcached \
      php-mysql \
      php7.2-opcache \
      php-readline \
      php-redis \
      php-soap \
      php-tidy \
      php-tokenizer \
      php-xml \
      php7.2-xsl \
      php-zip \
      # This shouldn't be included in the base image, but as legacy implementations lives on there was no other option :-(
      nodejs npm \
      # Gearman tools
      php-cli \
      imagemagick \
      jpegoptim \
      librsvg2-bin \
      libimage-exiftool-perl \
      opendkim \
      opendkim-tools \
      # I don't think the "build-tools" should be part of the base image either, but here we go anyways...
      curl git make g++ mysql-client && \
    rm -r /var/lib/apt/lists/* && \
    # Webpack: work-around for https://github.com/imagemin/mozjpeg-bin/issues/18
    curl "http://ppa.launchpad.net/hiberis/ppa/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.27-1ubuntu1~ppa1_amd64.deb" -o /tmp/libpng12.deb && \
    dpkg -i /tmp/libpng12.deb && \
    rm /tmp/libpng12.deb && \
    # NodeJS (webpack)
    rm /usr/bin/node /usr/bin/npm && \
    cd /opt && curl https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz | tar xz && \
    ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/bin/node && \
    ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/bin/npm && \
    # Create run-time directories
    mkdir -p ${APACHE_RUN_DIR} ${APACHE_LOG_DIR} /etc/apache2/certs-available

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
