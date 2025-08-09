# =========================
# FASE 1: INICIO
# =========================
FROM php:8.3-cli AS build

RUN apt-get update \
    && apt-get install -y libssl-dev pkg-config unzip git curl netcat-openbsd \
    && pecl install mongodb-1.21.0 \
    && docker-php-ext-enable mongodb

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY . .

RUN composer install --no-interaction --prefer-dist --optimize-autoloader
RUN npm install
RUN npm run build

# =========================
# FASE 2: PRODUCCIÓN
# =========================
FROM php:8.3-cli

RUN apt-get update \
    && apt-get install -y libssl-dev pkg-config unzip git curl netcat-openbsd ca-certificates \
    && update-ca-certificates \
    && pecl install mongodb-1.21.0 \
    && docker-php-ext-enable mongodb


WORKDIR /app

COPY --from=build /app /app

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8000

CMD ["/start.sh"]
