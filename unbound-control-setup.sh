#!/bin/sh

# Ruta base para claves y certificados
BASE_DIR="/etc/unbound"

# Archivos esperados
KEY_SERVER="$BASE_DIR/unbound_server.key"
CERT_SERVER="$BASE_DIR/unbound_server.pem"
KEY_CONTROL="$BASE_DIR/unbound_control.key"
CERT_CONTROL="$BASE_DIR/unbound_control.pem"

# Verifica si los archivos ya existen
if [ -f "$KEY_SERVER" ] && [ -f "$CERT_SERVER" ] && [ -f "$KEY_CONTROL" ] && [ -f "$CERT_CONTROL" ]; then
    echo "[INFO] Certificados TLS ya existen. Saltando generación."
    exit 0
fi

# Genera los certificados si no existen
echo "[INFO] Generando certificados TLS para el control remoto de Unbound..."

unbound-control-setup -d "$BASE_DIR"

# Verifica que se hayan generado correctamente
if [ -f "$KEY_SERVER" ] && [ -f "$CERT_SERVER" ] && [ -f "$KEY_CONTROL" ] && [ -f "$CERT_CONTROL" ]; then
    echo "[OK] Certificados TLS generados en $BASE_DIR."
else
    echo "[ERROR] Falló la generación de certificados TLS." >&2
    exit 1
fi
