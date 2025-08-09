# =========================
# FASE 1: BUILD
# =========================
FROM php:8.3-cli AS build

# Instalar dependencias necesarias para MongoDB y Node
RUN apt-get update \
    && apt-get install -y \
       libssl-dev \
       pkg-config \
       unzip \
       git \
       curl \
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

# =========================
# FASE 2: PRODUCCIÓN
# =========================
FROM php:8.3-cli

# Instalar extensión MongoDB en producción
RUN apt-get update \
    && apt-get install -y \
       libssl-dev \
       pkg-config \
       unzip \
       git \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copiar desde la fase build
COPY --from=build /app /app

# Comando por defecto de Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
