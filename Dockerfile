# ---------------------------
# Stage 1: Build dependencies
# ---------------------------
FROM composer:2 AS build

WORKDIR /app

# Copy all files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader


# ---------------------------
# Stage 2: Laravel Production Image
# ---------------------------
FROM php:8.2-fpm

# Install system packages
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev libonig-dev libpng-dev libxml2-dev libpq-dev

# PHP extensions required by Laravel
RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl

# Copy built app code
COPY --from=build /app /app

WORKDIR /app

# Expose port
EXPOSE 8000

# Start Laravel server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
