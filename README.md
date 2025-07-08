<!-- Logo de Unbound -->
<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/5/5a/Unbound_DNS_resolver_logo.svg" alt="Unbound logo" height="100">
</p>

# Unbound DNS Recursivo en Docker

Este proyecto contiene una imagen Docker personalizada y altamente optimizada de [Unbound](https://nlnetlabs.nl/projects/unbound/about/), pensada para brindar un servicio de resoluciÃ³n DNS recursivo, seguro, rÃ¡pido y completamente independiente (sin reenviadores).

## Tabla de contenido

1. [CaracterÃ­sticas](#caracterÃ­sticas)
2. [Estructura del Proyecto](#estructura-del-proyecto)
3. [CÃ³mo Construir la Imagen](#cÃ³mo-construir-la-imagen)
4. [CÃ³mo Ejecutar el Contenedor](#cÃ³mo-ejecutar-el-contenedor)
5. [docker-compose.yml](#docker-composeyml)
6. [entrypoint.sh](#entrypointsh)
7. [Makefile](#makefile)
8. [Scripts auxiliares](#scripts-auxiliares)
9. [Licencias y CrÃ©ditos](#licencias-y-crÃ©ditos)

---

## CaracterÃ­sticas

- Imagen basada en Alpine Linux (ligera y rÃ¡pida)
- ActualizaciÃ³n automÃ¡tica de `root.hints` en cada inicio
- Control remoto habilitado (vÃ­a `unbound-control`)
- Carga dinÃ¡mica de claves TLS si no existen
- Verbosidad nivel 1 para diagnÃ³stico sin excesivo logging
- Escucha en todos los interfaces (`0.0.0.0`) por UDP y TCP
- ExposiciÃ³n en el puerto 53 (por defecto, puede redireccionarse)

## Estructura del Proyecto

```
infra/unbound/
â”œâ”€â”€ etc/
â”‚   â”œâ”€â”€ unbound.conf
â”‚   â”œâ”€â”€ root.hints
â”‚   â””â”€â”€ claves TLS (.pem / .key)
â”œâ”€â”€ entrypoint.sh
â”œâ”€â”€ docker-compose.yml
â”œâ”€â”€ Dockerfile
â”œâ”€â”€ Makefile
â””â”€â”€ update-root.sh
```

## CÃ³mo Construir la Imagen

```bash
make build
```

## CÃ³mo Ejecutar el Contenedor

```bash
make run
```

O con Docker directo:

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

> ðŸ“Œ Puerto interno 53 â†’ expuesto como 5335. Referencia: [IETF DNS Ports](https://datatracker.ietf.org/doc/html/rfc1035)

---

## entrypoint.sh

Este script actualiza el archivo `root.hints` automÃ¡ticamente cada vez que se inicia el contenedor.

```bash
#!/bin/sh
set -e

ROOT_HINTS_URL="https://www.internic.net/domain/named.root"
ROOT_HINTS_FILE="/etc/unbound/root.hints"

echo "[Entrypoint] Actualizando root.hints desde ${ROOT_HINTS_URL}"
wget -qO "$ROOT_HINTS_FILE" "$ROOT_HINTS_URL" || echo "âš ï¸ No se pudo actualizar root.hints"

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

Permite actualizar manualmente el archivo de raÃ­ces desde el host:

```bash
#!/bin/sh
curl -o etc/root.hints https://www.internic.net/domain/named.root
```

---

## Licencias y CrÃ©ditos

- Imagen construida sobre [Alpine Linux](https://alpinelinux.org/)
- Proyecto principal: [Unbound DNS Resolver](https://nlnetlabs.nl/projects/unbound/about/)
- Autor de esta versiÃ³n: [Dagorret.com.ar](https://github.com/dagorret)
- Logo Unbound usado bajo permiso de [NLnet Labs](https://nlnetlabs.nl/)
- GNU Bash & Makefile logos: [GNU Artwork](https://www.gnu.org/graphics/)

Â© 2025 NLnet Labs / dagorret. Bajo licencia MIT salvo donde se indique lo contrario.
