#!/bin/sh

set -e

echo "[INFO] Actualizando root.hints desde https://www.internic.net/domain/named.root..."
curl -s https://www.internic.net/domain/named.root -o /etc/unbound/root.hints
echo "[OK] Archivo root.hints actualizado correctamente."

#if [ -f /etc/unbound/unbound-control-setup.sh ]; then
#   echo "[INFO] Configurando control remoto..."
#   sh /etc/unbound/unbound-control-setup.sh
#fi

echo "[INFO] Iniciando Unbound..."
exec unbound -d -c /etc/unbound/unbound.conf
