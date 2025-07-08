# Usa Alpine como base por su tamaño reducido y eficiencia
FROM alpine:latest

# Etiqueta de mantenimiento
LABEL maintainer="dagorret.com.ar"

# Instala paquetes necesarios: unbound y utilidades para debugging opcional
RUN apk update && \
    apk add --no-cache unbound unbound-libs bind-tools && \
    mkdir -p /etc/unbound && \
    chown -R unbound:unbound /etc/unbound

# Copia los archivos de configuración desde el contexto
COPY ./etc /etc/unbound

# Genera claves TLS para control remoto si no existen
RUN [ ! -f /etc/unbound/unbound_control.key ] && \
    unbound-control-setup -d /etc/unbound || true

# Expone el puerto DNS por UDP y TCP
EXPOSE 53/udp
EXPOSE 53/tcp

# Ejecuta Unbound como foreground (modo servicio dentro del contenedor)
CMD [ "unbound", "-d", "-c", "/etc/unbound/unbound.conf" ]
