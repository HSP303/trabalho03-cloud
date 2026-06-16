FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        sudo \
        procps \
        tar \
        gzip \
        coreutils \
        grep \
        findutils \
        iproute2 \
        vim \
        nano \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/ /app/scripts/
COPY source/ /app/source/
COPY README.md /app/README.md

RUN chmod +x /app/scripts/*.sh || true \
    && mkdir -p /app/backups /app/logs /app/evidencias /var/www/html

EXPOSE 80

CMD ["bash", "-c", "tail -f /dev/null"]
