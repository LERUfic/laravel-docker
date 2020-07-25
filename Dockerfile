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
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
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

RUN php artisan key:generate

# RUN php artisan route:cache
RUN php artisan config:cache

COPY init-storage/ storage/app/public

RUN chown -R www-data:www-data \
    /var/www/storage \
    /var/www/bootstrap/cache

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 9000
CMD ["php-fpm"]
