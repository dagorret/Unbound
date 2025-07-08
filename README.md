Unbound DNS Recursivo en Docker

Contenedor Docker liviano, seguro y eficiente que ejecuta Unbound, un resolvedor DNS recursivo validante. Está diseñado para brindar privacidad, velocidad, resiliencia y fácil integración con otras soluciones como AdGuard Home o Pi-hole.


---

⚙️ #1 Requisitos previos

Docker y Docker Compose instalados

Sistema operativo compatible (Ubuntu, Debian, Arch, Alpine, etc.)

Puerto 5335 disponible en el host (evita conflicto con otros DNS locales)

Conexión saliente a Internet para resolver recursivamente



---

📂 #2 Estructura del repositorio

Unbound/
├── Dockerfile              # Imagen basada en Alpine
├── docker-compose.yml     # Define volumen, puertos, configuración
├── Makefile                # Comandos para build/test
├── entrypoint.sh           # Script que actualiza root.hints
├── etc/
│   ├── unbound.conf        # Archivo de configuración principal
│   ├── root.hints          # Servidores raíz actualizados
│   └── claves TLS          # Generadas automáticamente para control remoto
├── scripts/                # Scripts auxiliares opcionales


---

🚀 #3 Instrucciones de uso

✏️ Paso 1: Configurar Unbound

Editá etc/unbound.conf si querés personalizar caché, reglas, DNSSEC, etc.

⚖️ Paso 2: Construir la imagen

make build

▶️ Paso 3: Ejecutar

docker compose up -d


---

📁 #4 Volúmenes y persistencia

El contenedor monta el directorio etc/ del host dentro del contenedor:

unbound.conf: configuración principal

root.hints: servidores raíz actualizados

Claves de control remoto TLS


Esto garantiza que las configuraciones sean persistentes y editables desde el host.


---

🔍 #5 Diagnóstico y administración

Consultar un dominio:

dig @127.0.0.1 -p 5335 example.com A +ttlunits

Ver estadísticas:

docker exec -it unbound unbound-control stats

Ver logs temporales:

docker logs -f unbound



---

🔄 #6 Actualización

↑ Imagen:

make rebuild

📅 root.hints:

El archivo root.hints se actualiza automáticamente al iniciar el contenedor con entrypoint.sh.

Podés forzarlo manualmente:

make update-roots


---

🪡 #7 Seguridad

Expone solo puerto 5335

No permite reenvío ni upstreams

Validación DNSSEC activada

TLS con control remoto (solo localhost)



---

📟 #8 Referencias

Unbound documentation

Alpine Unbound package

Mejores prácticas DNS recursivo



---

🛠️ #9 Desarrollo y contribuciones

Pull requests y sugerencias son bienvenidas.


---

🎨 #10 Personalización

Podés cambiar el puerto expuesto en docker-compose.yml

Integración simple con AdGuard Home usando forward custom DNS

Personalizá el caché o TTL en unbound.conf



---

Este proyecto está diseñado para ofrecer control total sobre tus resoluciones DNS, con énfasis en privacidad, rendimiento y estabilidad.

