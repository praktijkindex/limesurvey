#! /bin/bash

cp -r /uploadstruct/* /app/upload
chown -R www-data:www-data /app/upload
chmod -R 775 /app/upload

service apache2 restart
