FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    libzip-dev \
    && docker-php-ext-install zip

# Instalar extensiones necesarias
RUN docker-php-ext-install pdo pdo_mysql

# Instalar composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --optimize-autoloader --no-interaction

CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=${PORT}