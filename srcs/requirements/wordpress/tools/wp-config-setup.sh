#!/bin/bash


# configurar que si algun comando falla, termine el script
set -e

CONFIG_FILE="/var/www/html/wp-config.php"

# Si existe no hacer nada
if [ -f "$CONFIG_FILE" ]; then
	echo "> wp-config.php ya existe. No se ha generado ningun archivo"
	exit 0
fi

echo "> Generando nuevo archivo wp-config.php..."

# Copiamos desde ejemplo base
cp /var/www/html/wp-config-sample.php "$CONFIG_FILE"

# Reemplazamos constantes de conexion con valores de entorno
sed -i "s/database_name_here/${MYSQL_DATABASE}/" "$CONFIG_FILE"
sed -i "s/username_here/${MYSQL_USER}/" "$CONFIG_FILE"
sed -i "s/password_here/${MYSQL_PASSWORD}/" "$CONFIG_FILE"
sed -i "s/localhost/${MYSQL_HOST}/" "$CONFIG_FILE"

# Insertamos claves unicas generadas desde WordPress API
echo "> Insertando claves de autenticacion..."

SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sed -i "/AUTH_KEY/d" "$CONFIG_FILE"
sed -i "/SECURE_AUTH_KEY/d" "$CONFIG_FILE"
sed -i "/LOGGED_IN_KEY/d" "$CONFIG_FILE"
sed -i "/NONCE_KEY/d" "$CONFIG_FILE"
sed -i "/AUTH_SALT/d" "$CONFIG_FILE"
sed -i "/SECURE_AUTH_SALT/d" "$CONFIG_FILE"
sed -i "/LOGGED_IN_SALT/d" "$CONFIG_FILE"
sed -i "/NONCE_SALT/d" "$CONFIG_FILE"
printf '%s\n' "$SALT" >> "$CONFIG_FILE"

echo "> wp-config.php generado correctamente"


