FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
php php-mysqli curl dumb-init && \
apt clean

WORKDIR /var/www/html

COPY tools/adminer.php .

EXPOSE 8080

ENTRYPOINT ["dumb-init", "--"]
CMD ["php", "-S", "0.0.0.0:8080"]

