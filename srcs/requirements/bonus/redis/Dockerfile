# ------------------------------- #
# Dockerfile – Redis		  #
# ------------------------------- #

# En este dockerfile usaremos Alpine al ser mas ligero
FROM alpine:3.21

# # Evitamos prompts de interacción
# ENV REDIS_VERSION=7.2.5

RUN apk update && apk add --no-cache redis

# Creamos usuario por seguridad
RUN adduser -D -g '' redisuser && \
    mkdir -p /data && chown -R redisuser /data

# RUN mkdir -p /data
# VOLUME /data

EXPOSE 6379

COPY ./conf/redis.conf /usr/local/etc/redis/redis.conf

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]

# ENTRYPOINT ["redis-server", "--protected-mode", "no"]
