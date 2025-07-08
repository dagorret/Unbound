# Usa Alpine como base por su tamaño reducido y eficiencia
FROM alpine:latest

# Etiqueta de mantenimiento
LABEL maintainer="dagorret.com.ar"

# Instala Unbound, herramientas de red, y curl para actualizar root.hints
RUN apk update && \
    apk add --no-cache unbound unbound-libs bind-tools curl

# Crea el directorio de configuración y establece permisos
RUN mkdir -p /etc/unbound && \
    chown -R unbound:unbound /etc/unbound

# Copia los archivos de configuración (excepto las claves)
COPY ./etc/unbound.conf /etc/unbound/unbound.conf
#COPY ./etc/root.hints /etc/unbound/root.hints

# Copia el script de arranque
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Genera claves TLS necesarias para unbound-control dentro de la imagen
RUN unbound-control-setup -d /etc/unbound && \
    chown -R unbound:unbound /etc/unbound

# Expone el puerto DNS por UDP y TCP
EXPOSE 53/udp
EXPOSE 53/tcp

# Script de entrada que actualiza root.hints antes de iniciar Unbound
ENTRYPOINT ["/entrypoint.sh"]

# Comando por defecto
CMD [ "unbound", "-d", "-c", "/etc/unbound/unbound.conf" ]
