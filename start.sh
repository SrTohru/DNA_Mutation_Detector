#!/bin/bash
# Esperar a que la base de datos esté lista (opcional, ajusta el comando si usas MongoDB)
# Aquí puedes agregar un comando para esperar a que MongoDB Atlas esté disponible si quieres

# Ejecutar migraciones (forzado)
php artisan migrate --force

# Optimizar configuración cache
php artisan optimize

# Levantar servidor de Laravel (puedes usar php-fpm o serve)
php artisan serve --host=0.0.0.0 --port=8000
