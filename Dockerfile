FROM php:8.4.4-apache-bullseye

WORKDIR /home/www/code

ENV APACHE_DOCUMENT_ROOT /home/www/code/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
    && a2enmod rewrite

# Install dependencies
RUN apt update -y && apt install -y \
    zip \
    unzip \
    git

# Install composer \
COPY --from=composer:2.8.5 /usr/bin/composer /usr/bin/composer

# Copy source code
ADD src /home/www/code

# Install dependencies
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer install --no-dev

RUN mkdir -p /home/www/code/storage/app/public \
    && mkdir -p /home/www/code/storage/framework/cache \
    && mkdir -p /home/www/code/storage/framework/sessions \
    && mkdir -p /home/www/code/storage/framework/testing \
    && mkdir -p /home/www/code/storage/framework/views \
    && mkdir -p /home/www/code/storage/logs \
    && chmod -R 777 /home/www/code/storage

# Expose port 80
EXPOSE 80


