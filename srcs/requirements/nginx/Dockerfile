# ------------------------------- #
# Dockerfile – Servicio NGINX	  #
# ------------------------------- #

FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Instalamos NGINX y OpenSSL
RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl dumb-init && \
    apt clean


# Creamos carpetas para certificados
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Copiar configuracion personalizada de NGINX
COPY conf/default.conf /etc/nginx/sites-available/default

# Generar certificados SSL auto-firmados
RUN openssl req -x509 -nodes -days 365 \
    -subj "/C=ES/ST=Barcelona/L=42/0=Inception/CN=mmaltas.42.fr" \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt

# Creamos directorio raiz
RUN mkdir -p /var/www/html

# Exponemos puerto NGINX
EXPOSE 443

# Lanzamos nginx en primer plano
CMD ["dumb-init", "--", "nginx", "-g", "daemon off;"]
