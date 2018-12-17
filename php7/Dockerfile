FROM php:7.2-apache
############# Antoine
LABEL Description="This is a custom PHP7 Apache image"
LABEL maintainer="antoine.ngu@outlook.fr"

# system
USER root

RUN apt-get update && apt-get install -y \
        dos2unix \
        gettext-base \
        libcurl4-gnutls-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libxml2-dev \
        libxslt-dev \
        libpng-dev \
        mysql-client \
        gnupg2 \
        openssl \
        wget \
        git \
        sudo \
        zip \
        unzip \
        locales \
        && localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8 \
        && rm -rf /var/lib/apt/lists/*

# set locale env after initial install
ENV LANG='fr_FR.utf8' \
    LANGUAGE='fr_FR.fr' \
    LC_ALL='fr_FR.utf8' \
    TZ='Europe/Paris'
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install mysqli pdo pdo_mysql curl xml xsl gd mbstring soap zip \
    ## APCu && Xdebug
    && pecl install apcu-5.1.8 xdebug \
    && docker-php-ext-enable apcu

# composer
COPY php/composer-setup.sh /usr/local/bin
RUN chmod +x /usr/local/bin/composer-setup.sh \
    && /usr/local/bin/composer-setup.sh \
    && rm /usr/local/bin/composer-setup.sh

# nodejs & npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -y nodejs

# entrypoint
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# wait-for-it
COPY wait-for-it/wait-for-it.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wait-for-it.sh

RUN a2enmod rewrite proxy proxy_ajp proxy_balancer lbmethod_byrequests headers deflate
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
COPY etc/* /usr/local/etc/php/
RUN rm /var/log/apache2/error.log && ln -s /dev/stdout /var/log/apache2/error.log

# anvil
ENV HOME /home/antoine
RUN mkdir -p $HOME \
    && ln -ns /var/www/html/ $HOME/

# set src dir into home antoine
RUN groupadd -g 10000 antoine \
    && useradd -c "Antoine user" -d $HOME -u 10000 -g 10000 -m antoine \
    && adduser antoine sudo \
    && echo 'antoine   ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && chown -R antoine:antoine $HOME \
    && chmod -R 755 $HOME

USER antoine

# yarn
RUN sudo npm install yarn -g
WORKDIR $HOME

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]