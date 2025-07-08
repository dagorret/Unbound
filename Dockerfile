# Usa Alpine como base por su tamaño reducido y eficiencia
FROM alpine:latest

# Etiqueta de mantenimiento
LABEL maintainer="dagorret.com.ar"

# Instala paquetes necesarios: unbound, herramientas de red y curl para actualización root.hints
RUN apk update && \
    apk add --no-cache unbound unbound-libs bind-tools curl && \
    mkdir -p /etc/unbound && \
    chown -R unbound:unbound /etc/unbound

# Copia los archivos de configuración desde el contexto
COPY ./etc /etc/unbound

# Copia el script de entrada para actualización de root.hints
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Genera claves TLS necesarias para control remoto (unbound-control)
RUN unbound-control-setup -d /etc/unbound && \
    chown -R unbound:unbound /etc/unbound

# Expone el puerto DNS interno por UDP y TCP
EXPOSE 53/udp
EXPOSE 53/tcp

# Entrypoint que actualiza root.hints y luego lanza Unbound
ENTRYPOINT ["/entrypoint.sh"]

# Comando por defecto en modo foreground
CMD [ "unbound", "-d", "-c", "/etc/unbound/unbound.conf" ]
