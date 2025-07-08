Dockerfile optimizado para Unbound sobre Alpine Linux

------------------------------------------------------

Diseñado para ser eficiente, seguro, y con configuración externa

Incluye soporte para control remoto y actualización automática de root.hints

🔹 Imagen base liviana y actualizada

FROM alpine:latest

🔹 Metadatos del mantenedor

LABEL maintainer="dagorret.com.ar"

🔹 Instalación de Unbound y herramientas de diagnóstico DNS

RUN apk update && 
apk add --no-cache unbound unbound-libs bind-tools && 
mkdir -p /etc/unbound && 
chown -R unbound:unbound /etc/unbound

🔹 Copia archivos de configuración desde el contexto de build

COPY ./etc /etc/unbound

🔹 Genera claves de control remoto si no existen

RUN [ ! -f /etc/unbound/unbound_control.key ] && 
unbound-control-setup -d /etc/unbound || true

🔹 Copia el script de entrada (para actualizar root.hints, etc.)

COPY entrypoint.sh /entrypoint.sh RUN chmod +x /entrypoint.sh

🔹 Expone puertos DNS

EXPOSE 5335/udp EXPOSE 5353/tcp

🔹 Script de entrada

ENTRYPOINT ["/entrypoint.sh"]

🔹 Ejecución principal de Unbound

CMD ["unbound", "-d", "-c", "/etc/unbound/unbound.conf"]

