FROM alpine:latest

LABEL maintainer="TuNombre <tuemail@example.com>"

# Instalar dependencias necesarias
RUN apk add --no-cache build-base libevent-dev openssl-dev expat-dev curl \
    && curl -LO https://www.nlnetlabs.nl/downloads/unbound/unbound-latest.tar.gz \
    && tar -xzf unbound-latest.tar.gz \
    && cd unbound-* \
    && ./configure --prefix=/opt/unbound --with-libevent --with-ssl --with-pythonmodule=no \
    && make -j$(nproc) && make install \
    && /opt/unbound/sbin/unbound-control-setup -d /etc/unbound \
    && apk del build-base \
    && rm -rf /var/cache/apk/* /unbound-* /unbound-latest.tar.gz

# Copia el archivo de configuración (opcional si se monta desde volumen)
# COPY etc/unbound.conf /etc/unbound/unbound.conf

EXPOSE 5335/udp
EXPOSE 5335/tcp

CMD ["/opt/unbound/sbin/unbound", "-d", "-c", "/etc/unbound/unbound.conf"]
