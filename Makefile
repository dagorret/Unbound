# Makefile para Unbound DNS en Docker
# Permite construir, ejecutar, reiniciar y administrar el contenedor

# Nombre del contenedor
CONTAINER_NAME=unbound

# Construye la imagen Docker desde el Dockerfile
build:
	docker build -t dagorret/unbound .

# Ejecuta el contenedor con puertos DNS y volumen de configuración
run:
	@echo "🚀 Ejecutando contenedor $(CONTAINER_NAME)..."
	docker run --rm -it \
		--name $(CONTAINER_NAME) \
		-p 5335:53/udp -p 5335:53/tcp \
		-v $(PWD)/etc:/etc/unbound \
		dagorret/unbound

# Levanta el servicio con Docker Compose
up:
	docker compose up -d

# Detiene el contenedor
stop:
	docker compose down

# Reconstruye sin usar caché y actualiza desde Git
rebuild:
	@echo "🔄 Actualizando y reconstruyendo imagen..."
	git pull
	docker compose build --no-cache
	docker compose up -d

# Ver estadísticas en tiempo real con unbound-control
stats:
	docker exec -it $(CONTAINER_NAME) unbound-control stats_noreset

# Ver actividad en tiempo real (consultas recibidas)
watch:
	docker exec -it $(CONTAINER_NAME) unbound-control log_reopen

# Purgar la caché DNS
flush:
	docker exec -it $(CONTAINER_NAME) unbound-control flush_zone .

# Mostrar logs en vivo
logs:
	docker compose logs -f
