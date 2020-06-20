FROM php:7.4-fpm

COPY . /var/www

WORKDIR /var/www

RUN apt-get update && \
    apt-get install -y \
    git \
    zip \
    curl

RUN docker-php-ext-install pdo_mysql

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install \
    && php composer.phar dumpautoload -o \
    && rm composer.phar

RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

RUN mv .env.example .env

RUN php artisan key:generate

# RUN php artisan migrate:reset
# RUN php artisan migrate
# RUN php artisan db:seed

RUN php artisan route:clear
RUN php artisan config:clear
RUN php artisan cache:clear
RUN php artisan storage:link

RUN php artisan route:cache
RUN php artisan config:cache

COPY init-storage/ storage/app/public

RUN chown -R www-data:www-data \
    /var/www/storage \
    /var/www/bootstrap/cache

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 9000
CMD ["php-fpm"]
