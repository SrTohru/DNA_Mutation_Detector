# Usamos imagen oficial PHP con extensiones comunes para Laravel
FROM php:8.2-fpm

# Instalar dependencias del sistema y extensiones PHP necesarias
RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev zip libpng-dev libonig-dev libxml2-dev \
    libssl-dev \
    nodejs npm \
    && docker-php-ext-install pdo_mysql zip mbstring exif pcntl bcmath gd sockets \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb

# Instalar Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos de proyecto al contenedor
COPY . .

# Instalar dependencias PHP sin interacción y optimizando autoload
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Instalar dependencias Node.js y construir assets frontend
RUN npm install
RUN npm run build

# Optimizar Laravel y permisos (sin migraciones aquí)
RUN php artisan optimize \
    && chmod -R 777 storage bootstrap/cache \
    && php artisan storage:link

# Copiar script de arranque
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Puerto que exponemos
EXPOSE 8000

# Ejecutar script de arranque al iniciar el contenedor
CMD ["/start.sh"]
