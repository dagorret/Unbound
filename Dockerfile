# Usa Alpine Linux por su bajo tamaño y seguridad
FROM alpine:latest

# Información del mantenedor
LABEL maintainer="dagorret.com.ar"

# Instala Unbound y herramientas útiles (como dig)
RUN apk update && \
    apk add --no-cache unbound unbound-libs bind-tools && \
    mkdir -p /etc/unbound && \
    chown -R unbound:unbound /etc/unbound

# Copia configuración desde ./etc del host al contenedor
COPY ./etc /etc/unbound

# Copia el script de entrada que actualiza root.hints antes de iniciar
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Genera claves para control remoto si aún no existen
RUN [ ! -f /etc/unbound/unbound_control.key ] && \
    unbound-control-setup -d /etc/unbound || true

# Expone el puerto alternativo 5335 (TCP y UDP) para evitar conflictos con servicios locales
EXPOSE 5335/udp
EXPOSE 5335/tcp

# Script que actualiza raíces y luego lanza Unbound
ENTRYPOINT ["/entrypoint.sh"]

# Comando por defecto: inicia Unbound en foreground y con configuración externa
CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]
