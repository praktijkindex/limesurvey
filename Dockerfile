FROM php:apache

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive
ENV NR_INSTALL_SILENT 1

RUN apt-get update && \
    apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
      libldb-dev \
      libldap2-dev \
      libc-client-dev \
      libkrb5-dev \
      libmysqlclient-dev \
      mysql-client && \
    apt-get clean

RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && \
    ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so

RUN docker-php-source extract && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install -j$(nproc) gd ldap zip imap pdo_mysql && \
    docker-php-source delete

RUN apt-get update && \
    apt-get -yq install wget && \
    wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list

RUN apt-get update && \
    apt-get -y install \
      newrelic-php5 \
      newrelic-daemon && \
    apt-get clean

RUN rm -rf /app
ADD limesurvey.tar.bz2 /
RUN cp -r /limesurvey/* /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

RUN service apache2 restart
