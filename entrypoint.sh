#!/bin/sh

# ----------------------------
# Script de inicio de Unbound
# ----------------------------
# Este script actualiza automáticamente el archivo root.hints desde IANA
# antes de iniciar el servicio de Unbound en modo recursivo.
#
# Requiere:
# - curl (presente en Alpine por defecto en esta imagen base)
# - acceso a internet para descargar las raíces DNS
# - archivo de configuración en /etc/unbound/unbound.conf

ROOT_HINTS_URL="https://www.internic.net/domain/named.root"
ROOT_HINTS_FILE="/etc/unbound/root.hints"

echo "[INFO] Actualizando root.hints desde $ROOT_HINTS_URL..."
if curl -fsSL "$ROOT_HINTS_URL" -o "$ROOT_HINTS_FILE"; then
  echo "[OK] Archivo root.hints actualizado correctamente."
else
  echo "[WARN] No se pudo actualizar root.hints. Se utilizará el archivo existente si está disponible."
fi

# Verifica existencia del archivo de configuración
CONFIG_FILE="/etc/unbound/unbound.conf"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "[ERROR] No se encontró $CONFIG_FILE. Abortando."
  exit 1
fi

echo "[INFO] Iniciando Unbound..."
exec unbound -d -c "$CONFIG_FILE"
