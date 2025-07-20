#!/bin/sh
set -e

#echo ">> Esperando a que WordPress esté listo..."
#until wp core is-installed --allow-root 2>/dev/null; do
#	sleep 2
#done

# Instalamos WordPress si no está instalado
if ! wp core is-installed --allow-root; then
	echo "> Instalando WordPress..."
	wp core install \
		--url="$DOMAIN_NAME" \
		--title="Inception Site" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root
fi

# Crear admin si no existe
if ! wp user get "$WP_ADMIN_USER" --field=ID --allow-root >/dev/null 2>&1; then
	echo ">> Creando usuario administrador..."
	wp user create "$WP_ADMIN_USER" "$WP_ADMIN_EMAIL" \
		--user_pass="$WP_ADMIN_PASSWORD" \
		--role=administrator \
		--allow-root
else
	echo ">> Usuario administrador ya existe"
fi

# Crear lector si no existe
if ! wp user get "$WP_USER" --field=ID --allow-root >/dev/null 2>&1; then
	echo ">> Creando usuario lector..."
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=subscriber \
		--allow-root
else
	echo ">> Usuario lector ya existe"
fi

echo ">> Usuarios creados correctamente."

