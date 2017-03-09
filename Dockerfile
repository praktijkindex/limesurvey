FROM php:apache

ENV TERM xterm
ENV DEBIAN_FRONTEND noninteractive
ENV NR_INSTALL_SILENT 1

RUN apt-get update && \
    apt-get -yq install wget && \
    wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list

RUN apt-get update && \
    apt-get -yq install newrelic-php5 newrelic-daemon

RUN rm -rf /app
ADD limesurvey.tar.bz2 /
RUN cp -r /limesurvey/* /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

RUN service apache2 restart
