# Usa una imagen base mínima
FROM alpine:latest

# Argumento opcional para UID y GID
ARG UNBOUND_UID=1000
ARG UNBOUND_GID=1000

# Instala dependencias necesarias y crea usuario
RUN apk update && apk add --no-cache unbound curl \
    && addgroup -g $UNBOUND_GID unbound \
    && adduser -S -D -H -u $UNBOUND_UID -G unbound unbound

# Crea los directorios necesarios con permisos
RUN mkdir -p /etc/unbound && chown -R unbound:unbound /etc/unbound

# Copia archivos de configuración
COPY etc/unbound.conf /etc/unbound/unbound.conf
COPY root.hints /etc/unbound/root.hints
COPY entrypoint.sh /entrypoint.sh
COPY unbound-control-setup.sh /etc/unbound/unbound-control-setup.sh

# Da permisos de ejecución al entrypoint y scripts
RUN chmod +x /entrypoint.sh /etc/unbound/unbound-control-setup.sh

# Ejecuta como usuario no root por defecto
USER unbound:unbound

# Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
