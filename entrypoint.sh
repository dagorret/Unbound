#!/bin/sh
set -e

echo "[INFO] Actualizando root.hints desde IANA..."
curl -fsSL -o /etc/unbound/root.hints https://www.internic.net/domain/named.root || {
    echo "[WARNING] No se pudo actualizar root.hints. Usando versión local existente."
}

echo "[INFO] Iniciando Unbound con configuración en /etc/unbound/unbound.conf"
exec unbound -d -c /etc/unbound/unbound.conf
