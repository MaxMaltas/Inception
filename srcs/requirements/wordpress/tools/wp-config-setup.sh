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

# Descargar claves SALT
echo "> Descargando claves de autenticacion desde WordPress API..."
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

# Eliminar defines duplicados o residuales
sed -i '/define.(WP_CACHE\|WP_REDIS_HOST\|WP_REDIS_PORT\|WP_HOME\|WP_SITEURL\|FORCE_SSL_ADMIN\|COOKIE_DOMAIN)/d' "$CONFIG_FILE"
sed -i '/define.(AUTH_KEY\|SECURE_AUTH_KEY\|LOGGED_IN_KEY\|NONCE_KEY\|AUTH_SALT\|SECURE_AUTH_SALT\|LOGGED_IN_SALT\|NONCE_SALT)/d' "$CONFIG_FILE"

# Insertar todo justo antes del require_once
awk -v domain="$DOMAIN_NAME" -v salt="$SALT" '
/require_once ABSPATH/ {
    print "// --- Configuración personalizada ---"
    print "define('\''WP_CACHE'\'', true);"
    print "define('\''WP_REDIS_HOST'\'', '\''redis'\'');"
    print "define('\''WP_REDIS_PORT'\'', 6379);"
    print "define('\''WP_HOME'\'', '\''https://" domain "'\'');"
    print "define('\''WP_SITEURL'\'', '\''https://" domain "'\'');"
    print "define('\''FORCE_SSL_ADMIN'\'', true);"
    print "define('\''COOKIE_DOMAIN'\'', $_SERVER['\''HTTP_HOST'\'']);"
    print ""
    print "// --- Claves SALT generadas dinámicamente ---"
    print salt
    print ""
}
{ print }
' "$CONFIG_FILE" > /tmp/wp-config.tmp && mv /tmp/wp-config.tmp "$CONFIG_FILE"

echo "> wp-config.php generado correctamente"

