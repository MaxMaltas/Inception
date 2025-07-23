# requirements/wordpress/tools/entrypoint.sh
#!/bin/sh
set -e

#!/bin/bash

until mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" 2>/dev/null; do
  echo "Esperando a que MariaDB esté totalmente operativa..."
  sleep 2
done


echo "Esperando a que Redis esté disponible..."
until redis-cli -h redis ping | grep -q PONG; do
  sleep 1
done
echo "Redis OK"

echo "Iniciando configuración de WordPress..."
# aquí llamas a tu script de setup o lanzas PHP-FPM


echo ">> Ejecutando configuración inicial de WordPress..."

/usr/local/bin/wp-config-setup.sh
/usr/local/bin/create-wp-users.sh

# Lanzar el proceso principal: PHP-FPM
echo ">> Iniciando PHP-FPM..."
exec php-fpm7.4 -F

