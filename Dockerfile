# =========================
# FASE 1: BUILD
# =========================
FROM php:8.3-cli AS build

# Instalar dependencias necesarias para MongoDB, Composer y Node
RUN apt-get update \
    && apt-get install -y libssl-dev pkg-config php8.3-dev unzip git curl netcat-openbsd \
    && pecl install mongodb-1.21.0 \
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

# =========================
# FASE 2: PRODUCCIÓN
# =========================
FROM php:8.3-cli

# Instalar extensiones necesarias
RUN apt-get update \
    && apt-get install -y libssl-dev pkg-config php8.3-dev unzip git netcat-openbsd \
    && pecl install mongodb-1.21.0 \
    && docker-php-ext-enable mongodb

WORKDIR /app

# Copiar desde la fase de build
COPY --from=build /app /app

# Copiar script de arranque
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exponer puerto
EXPOSE 8000

# Comando de inicio
CMD ["/start.sh"]
