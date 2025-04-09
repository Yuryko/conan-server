FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nginx \
    python3 \
    python3-pip \
    git \
    cmake \
    build-essential \
    openssl \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install conan conan-server

RUN useradd -m conan && \
    mkdir -p /home/conan/.conan_server && \
    mkdir -p /home/conan/.conan_server/logs && \
    chown -R conan:conan /home/conan/.conan_server

# Копируем предварительно созданные SSL-сертификаты (если есть)
# COPY ssl.crt /etc/ssl/certs/
# COPY ssl.key /etc/ssl/private/

COPY nginx.conf /etc/nginx/nginx.conf
COPY server.conf /home/conan/.conan_server/

# Порты:
# - 8080: HTTP (редирект на HTTPS)
# - 8443: HTTPS
# - 9300: Conan Server (если нужен прямой доступ)
EXPOSE 8080 8443 9300

CMD bash -c 'su - conan -c "conan_server > /home/conan/.conan_server/data/logs/conan_server.log 2>&1 &" && \
    nginx -g "daemon off;"'
