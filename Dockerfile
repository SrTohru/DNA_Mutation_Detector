# =========================
# FASE 1: BUILD
# =========================
FROM php:8.3-cli AS build

# Instalar dependencias necesarias para MongoDB y Composer
RUN apt-get update \
    && apt-get install -y libssl-dev pkg-config php-pear php-dev unzip git curl \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Instalar Node 20 para Vite
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Instalar Composer manualmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

# Copiar el código de la app
COPY . .

# Instalar dependencias PHP y JS
RUN composer install --no-interaction --prefer-dist --optimize-autoloader
RUN npm install
RUN npm run build

# Ejecutar migraciones y optimizar Laravel
RUN php artisan migrate --force \
    && php artisan optimize \
    && chmod -R 777 storage bootstrap/cache \
    && php artisan storage:link
# Instalar dependencias PHP y JS
# =========================
# FASE 2: PRODUCCIÓN
# =========================
FROM php:8.3-cli

# Instalar extensión MongoDB en la fase final también
RUN apt-get update \
    && apt-get install -y libssl-dev pkg-config php-pear php-dev unzip git
