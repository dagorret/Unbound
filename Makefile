# Nombre de la imagen a construir
IMAGE_NAME=dagorret/unbound
# Puerto donde escucha localmente el servicio DNS
DNS_PORT=5335

# 🛠️ Build: compila la imagen desde el Dockerfile
build:
	@echo "🔨 Construyendo la imagen Docker..."
	docker build -t $(IMAGE_NAME) .

# 🚀 Run: inicia el contenedor de forma interactiva con volumen de configuración
run:
	@echo "🚀 Ejecutando contenedor Docker en puerto $(DNS_PORT)..."
	docker run -d --name unbound \
		-p $(DNS_PORT):53/udp -p $(DNS_PORT):53/tcp \
		-v $(PWD)/etc:/etc/unbound \
		$(IMAGE_NAME)

# 🔁 Restart: reinicia el contenedor (útil tras cambios en configuración)
restart:
	@echo "🔄 Reiniciando contenedor..."
	docker restart unbound

# 🧹 Clean: borra el contenedor y la imagen (¡precaución!)
clean:
	@echo "🧹 Eliminando contenedor e imagen..."
	-docker rm -f unbound
	-docker rmi -f $(IMAGE_NAME)

# 📋 Logs: muestra los logs del contenedor
logs:
	docker logs -f unbound

# 💬 Shell: entra al contenedor con un shell interactivo
shell:
	docker exec -it unbound sh

# 🔑 Setup-control: genera claves para control remoto si no existen
setup-control:
	@echo "🔐 Generando claves de control..."
	docker run --rm -v $(PWD)/etc:/etc/unbound alpine:latest \
		sh -c "apk add --no-cache unbound && unbound-control-setup -d /etc/unbound"
