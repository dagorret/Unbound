

Unbound DNS Resolver en Docker

 

📌 Descripción General

Contenedor Docker personalizado de Unbound basado en Alpine Linux. Optimizado para:

Resolución DNS recursiva completa y directa a las raíces

Desempeño y privacidad máximos

Autoactualización de root.hints



---

📁 Estructura del Proyecto

.
├── etc/
│   ├── unbound.conf               # Configuración principal
│   ├── root.hints                 # Raíces actualizadas
│   ├── *.pem / *.key              # Archivos de control remoto
├── docker-compose.yml            # Orquestador de servicios
├── Dockerfile                    # Construcción de imagen
├── Makefile                      # Comandos comunes
├── entrypoint.sh                 # Script inicial de arranque
├── update-root.sh                # Script para actualizar root.hints


---

🚀 Uso Básico

Construcción de la imagen:

make build

Inicio del contenedor:

make up

Actualización de root.hints:

make update-root

Control remoto:

docker exec -it unbound unbound-control stats


---

🔧 docker-compose.yml

version: "3.9"

services:
  unbound:
    container_name: unbound
    build: .
    ports:
      - "5335:53/udp"
      - "5335:53/tcp"
    volumes:
      - ./etc:/etc/unbound
    restart: unless-stopped

> ℹ️ Referencias:

Docker Compose syntax

Unbound manual





---

🐳 Dockerfile (resumen)

Basado en Alpine para mínima huella

Expone el puerto 53 UDP/TCP

Usa entrypoint.sh para descargar raíces al inicio

Permite configuración persistente con bind-mount ./etc


FROM alpine:latest
LABEL maintainer="dagorret.com.ar"
...

> Referencias:

Unbound NLnetLabs GitHub

Unbound Alpine Package





---

🛠️ Makefile (resumen)

build:
	docker compose build
up:
	docker compose up -d
update-root:
	./update-root.sh
stats:
	docker exec -it unbound unbound-control stats


---

📊 Estadísticas y monitoreo

docker exec -it unbound unbound-control stats_noreset
docker exec -it unbound unbound-control dump_cache | less


---

🧪 Prueba DNS

dig @127.0.0.1 -p 5335 unrc.edu.ar A +ttlunits


---

🖼️ Ilustraciones (con atribución)



> Imagen cortesía de Wikimedia Commons, licencia GNU Free Documentation License.




---

⚖️ Licencia y atribuciones

Este proyecto:

Usa Unbound, software desarrollado por NLnet Labs

Está licenciado bajo la licencia BSD-3-Clause


Unbound (C) 2007–2025 NLnet Labs. All rights reserved.


---

¿Querés agregar ejemplos avanzados como forward-zone, DNS-over-TLS, o monitoreo por Prometheus? Puedo extender el README en nuevas secciones.

