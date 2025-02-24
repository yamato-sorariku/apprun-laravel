FROM php:8.4.4-apache-bullseye

WORKDIR /app

ENV APACHE_DOCUMENT_ROOT /app/public

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
COPY ./src /app

# Install dependencies
RUN composer install

# Expose port 80
EXPOSE 80


