# requirements/wordpress/tools/entrypoint.sh
#!/bin/sh
set -e

echo ">> Ejecutando configuración inicial de WordPress..."

/usr/local/bin/wp-config-setup.sh
/usr/local/bin/create-wp-users.sh

# Lanzar el proceso principal: PHP-FPM
echo ">> Iniciando PHP-FPM..."
exec php-fpm7.4 -F

