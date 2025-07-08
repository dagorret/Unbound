FROM alpine:latest

# Variables de entorno para UID/GID opcionales
ARG UNBOUND_UID=100
ARG UNBOUND_GID=100

# Instala Unbound y herramientas útiles
RUN apk update && apk add --no-cache unbound curl

# Crea carpetas necesarias y copia configuración
RUN mkdir -p /etc/unbound
COPY etc/unbound/unbound.conf /etc/unbound/unbound.conf
COPY entrypoint.sh /entrypoint.sh
COPY unbound-control-setup.sh /etc/unbound/unbound-control-setup.sh

# Copia root.hints si lo tenés local (si no, omitilo)
# COPY root.hints /etc/unbound/root.hints

RUN chmod +x /entrypoint.sh /etc/unbound/unbound-control-setup.sh

# Expone puertos DNS
EXPOSE 53/udp
EXPOSE 53/tcp

# Usa el usuario ya creado por el paquete unbound
USER unbound

ENTRYPOINT ["/entrypoint.sh"]
