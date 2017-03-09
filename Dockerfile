FROM mmorejon/apache2-php5

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
RUN mv /limesurvey /app; \
	mkdir -p /uploadstruct; \
	chown -R www-data:www-data /app

RUN cp -r /app/upload/* /uploadstruct ; \
	chown -R www-data:www-data /uploadstruct

RUN chown www-data:www-data /var/lib/php5

ADD apache_default /etc/apache2/sites-available/000-default.conf
ADD start.sh /

RUN chmod +x /start.sh

VOLUME /app/upload

CMD ["/start.sh"]
