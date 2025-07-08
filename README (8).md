
<!-- Logo de Unbound -->
<p align="center">
  <img src="https://nlnetlabs.nl/logo/unbound.svg" alt="Unbound logo" height="100">
</p>

# Unbound DNS Recursivo en Docker

Este proyecto contiene una imagen Docker personalizada y altamente optimizada de [Unbound](https://nlnetlabs.nl/projects/unbound/about/), pensada para brindar un servicio de resolución DNS recursivo, seguro, rápido y completamente independiente (sin reenviadores).

## Tabla de contenido

1. [Características](#características)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [Cómo Construir la Imagen](#cómo-construir-la-imagen)
4. [Cómo Ejecutar el Contenedor](#cómo-ejecutar-el-contenedor)
5. [docker-compose.yml](#docker-composeyml)
6. [entrypoint.sh](#entrypointsh)
7. [Makefile](#makefile)
8. [Scripts auxiliares](#scripts-auxiliares)
9. [Licencias y Créditos](#licencias-y-créditos)

---

## Características

- Imagen basada en Alpine Linux (ligera y rápida)
- Actualización automática de `root.hints` en cada inicio
- Control remoto habilitado (vía `unbound-control`)
- Carga dinámica de claves TLS si no existen
- Verbosidad nivel 1 para diagnóstico sin excesivo logging
- Escucha en todos los interfaces (`0.0.0.0`) por UDP y TCP
- Exposición en el puerto 53 (por defecto, puede redireccionarse)

---

## Estructura del Proyecto

```
infra/unbound/
├── etc/
│   ├── unbound.conf
│   ├── root.hints
│   └── claves TLS (.pem / .key)
├── entrypoint.sh
├── docker-compose.yml
├── Dockerfile
├── Makefile
└── update-root.sh
```

---

## Cómo Construir la Imagen

```bash
make build
```

---

## Cómo Ejecutar el Contenedor

```bash
make run
```

O directamente con Docker:

```bash
docker run -d \
  --name unbound \
  -p 5335:53/udp -p 5335:53/tcp \
  -v $(pwd)/etc:/etc/unbound \
  dagorret/unbound
```

---

## docker-compose.yml

```yaml
version: '3.9'

services:
  unbound:
    container_name: unbound
    image: dagorret/unbound:latest
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "5335:53/udp"
      - "5335:53/tcp"
    volumes:
      - ./etc:/etc/unbound
    restart: unless-stopped
```

> 📌 Puerto interno 53 → expuesto como 5335. Referencia: [IETF DNS Ports](https://datatracker.ietf.org/doc/html/rfc1035)

---

## entrypoint.sh

Este script actualiza el archivo `root.hints` automáticamente cada vez que se inicia el contenedor.

```bash
#!/bin/sh
set -e

ROOT_HINTS_URL="https://www.internic.net/domain/named.root"
ROOT_HINTS_FILE="/etc/unbound/root.hints"

echo "[Entrypoint] Actualizando root.hints desde ${ROOT_HINTS_URL}"
wget -qO "$ROOT_HINTS_FILE" "$ROOT_HINTS_URL" || echo "⚠️ No se pudo actualizar root.hints"

exec unbound -d -c /etc/unbound/unbound.conf
```

---

## Makefile

```make
build:
	docker build -t dagorret/unbound .

run:
	docker run -d \
	  --name unbound \
	  -p 5335:53/udp -p 5335:53/tcp \
	  -v $(PWD)/etc:/etc/unbound \
	  dagorret/unbound

stop:
	docker stop unbound || true && docker rm unbound || true

logs:
	docker logs -f unbound
```

---

## Scripts auxiliares

### update-root.sh

Permite actualizar manualmente el archivo de raíces desde el host:

```bash
#!/bin/sh
curl -o etc/root.hints https://www.internic.net/domain/named.root
```

---

## Licencias y Créditos

- Imagen construida sobre [Alpine Linux](https://alpinelinux.org/)
- Proyecto principal: [Unbound DNS Resolver](https://nlnetlabs.nl/projects/unbound/about/)
- Autor de esta versión: [Dagorret.com.ar](https://github.com/dagorret)
- Logo Unbound usado bajo permiso de [NLnet Labs](https://nlnetlabs.nl/)
- GNU Bash & Makefile logos: [GNU Artwork](https://www.gnu.org/graphics/)

© 2025 NLnet Labs / dagorret. Bajo licencia MIT salvo donde se indique lo contrario.
