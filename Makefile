# ----------------------------
# Makefile para imagen Unbound
# ----------------------------
# Provee comandos para construir la imagen Docker, ejecutarla, y actualizar raíces DNS manualmente.

# Nombre de la imagen
IMAGE_NAME = dagorret/unbound
CONTAINER_NAME = unbound

# Versión de Unbound deseada (puede extraerse dinámicamente si se prefiere)
UNBOUND_VERSION ?= latest

# Ruta al archivo de raíces DNS dentro del árbol del build
ROOT_HINTS_URL = https://www.internic.net/domain/named.root
ROOT_HINTS_FILE = etc/root.hints

## build: Construye la imagen Docker local
build:
	@echo "🔧 Construyendo imagen $(IMAGE_NAME)..."
	docker build -t $(IMAGE_NAME) .

## run: Lanza el contenedor en modo interactivo para pruebas
run:
	@echo "🚀 Ejecutando contenedor $(CONTAINER_NAME)..."
	docker run --rm -it \
		--name $(CONTAINER_NAME) \
		-p 5335:5335/udp -p 5335:5335/tcp \
		-v $$(pwd)/etc:/etc/unbound \
		$(IMAGE_NAME)

## update-root: Descarga manualmente el archivo root.hints actualizado desde IANA
update-root:
	@echo "🌐 Descargando root.hints desde $(ROOT_HINTS_URL)..."
	curl -fsSL $(ROOT_HINTS_URL) -o $(ROOT_HINTS_FILE)
	@echo "✅ Archivo actualizado: $(ROOT_HINTS_FILE)"

## clean: Elimina la imagen construida localmente (uso con cuidado)
clean:
	@echo "🧹 Eliminando imagen $(IMAGE_NAME)..."
	docker rmi $(IMAGE_NAME) || true

## help: Muestra esta ayuda
help:
	@echo "Comandos disponibles:"
	@grep -E '^##' $(MAKEFILE_LIST) | sed -e 's/## //'

.DEFAULT_GOAL := help
