FROM debian:bullseye

# Modo no interactivo
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar y preinstalar paquetes
RUN apt update && apt upgrade -y && \
apt install -y mariadb-server mariadb-client && \
apt clean

# Copiamos script inicializacion
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

# ConfigurMOS EL BIND-ADRESS para escuchar de todas la direcciones
RUN sed -i "s/^bind-address\s*=.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Definimos variables de entorno
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ENV MYSQL_USER=${MYSQL_USER}
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

# Exponemos puerto
EXPOSE 3306

# Proceso inicial
ENTRYPOINT ["/init.sh"]
