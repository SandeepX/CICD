# ============================================
# Dockerfile for Laravel CI/CD Project
# Multi-stage build for optimized image
# ============================================

# Stage 1: Build dependencies & assets
FROM php:8.4-fpm AS builder

# Install system dependencies including Node.js
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Install Composer dependencies (without running scripts yet)
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

# Install npm dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy remaining source files and build frontend assets
COPY . .
RUN npm run build

# Stage 2: Production image
FROM php:8.4-fpm AS production

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Redis extension (for caching)
RUN pecl install redis && docker-php-ext-enable redis

# Set working directory
WORKDIR /var/www/html

# Copy vendored dependencies and built assets from builder
COPY --from=builder /var/www/html/vendor /var/www/html/vendor
COPY --from=builder /var/www/html/node_modules /var/www/html/node_modules
COPY --from=builder /var/www/html/public/build /var/www/html/public/build
COPY . .

# Set permissions for Laravel runtime
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 9000 for PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
