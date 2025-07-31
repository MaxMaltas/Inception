#!/bin/bash

# MARCADOR

INIT_MARKER="/var/lib/mysql/.initialized"

echo ${INIT_MARKER}

if [ ! -f "$INIT_MARKER" ]; then
	echo "> Iniciando base datos de MariaDB..."
	mysql_install_db --user=mysql --basedir=/usr --ldata=/var/lib/mysql
# Inicia servicio en segundo plano
	mysqld_safe --datadir=/var/lib/mysql & #--bind-adress=0.0.0.0 &
	sleep 15

	echo "> Verificando estado del servicio:"
# service mysql status

# Esperar hasta que este disponible
	until mysqladmin ping --protocol=socket --socket=/run/mysqld/mysqld.sock --silent; do # -h 127.0.0.1 --silent; do
		echo "Esperando MariaDB..."
		sleep 1
	done

	HOSTNAME=mariadb
# Crear base de datos
	echo "> Configurando base de datos..."

	mysql -u root -h localhost <<-EOSQL # mysql -u root --socket=/run/mysqld/mysqld.sock <<-EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
	FLUSH PRIVILEGES;
	EOSQL

	echo "> MariaDB listo y configurado "


# Parar MariaDB
# service mysql stop
	echo "Cierra mysqladmin"
	mysqladmin shutdown -u root -p"${MYSQL_ROOT_PASSWORD}" --socket=/run/mysqld/mysqld.sock
	
	echo "Inicializacion completa. MArcar estado...."
	touch "${INIT_MARKER}"
fi

echo "Ejecuta mysql_safe en primer plano "
# Ejecutar mysql_safe
exec mysqld_safe --datadir=/var/lib/mysql  #--bind-adress=0.0.0.0


