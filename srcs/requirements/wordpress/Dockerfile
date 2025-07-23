FROM debian:bullseye

# Evitar prompts de configuracion de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Actualizamos paquetes, anyadimos PHP-FPM y extensiones
RUN apt update && apt upgrade -y && \
apt install -y php php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip php-redis redis-tools default-mysql-client \
wget unzip curl tar dumb-init && apt clean

# Creamos directorio WordPress
RUN mkdir -p /var/www/html

# Establecer directorio de trabajo por defecto
WORKDIR /var/www/html

# Descargar Wordpress desde sitio oficial
RUN curl -O https://wordpress.org/latest.tar.gz && \
tar -xzf latest.tar.gz && cp -a wordpress/. ./ && \
rm -rf wordpress latest.tar.gz

# Fix para que PHP-FPM escuche en puerto TCP 9000
RUN sed -i "s|^listen = .*|listen = 0.0.0.0:9000|" /etc/php/7.4/fpm/pool.d/www.conf

# Instalamos WP-CLI para creacion de usiarios
ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

# Copiamos script que genera wp-config.php con variable entorno
COPY tools/wp-config-setup.sh /usr/local/bin/wp-config-setup.sh
COPY tools/create-wp-users.sh /usr/local/bin/create-wp-users.sh
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/*.sh

# Declaramos variables
ENV WP_DB_NAME=${MYSQL_DATABASE}
ENV WP_DB_USER=${MYSQL_USER}
ENV WP_DB_PASSWORD=${MYSQL_PASSWORD}
ENV WP_DB_HOST=${MYSQL_HOST}

# Creamos el directorio necesario para el socket de php
RUN mkdir -p /run/php

# Creamos el wp-config.php al arrancar y luego lanzamos PHP-FPM como proceso principal
# CMD ["dumb-init", "--", "sh", "-c", "/usr/local/bin/wp-config-setup.sh && php-fpm7.4 -F"]
ENTRYPOINT ["dumb-init", "--", "/usr/local/bin/entrypoint.sh"]
