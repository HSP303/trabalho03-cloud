#!/bin/bash

# Trabalho 03 - Tarefa 05
# Tema: Sistema para Videomonitoramento
# Objetivo: publicar site estático no Apache.

ORIGEM="/app/source"
DESTINO="/var/www/html"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/05_deploy.log"

registrar_log() {
    local mensagem="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensagem" | tee -a "$LOG_FILE"
}

validar_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "[ERRO] Execute este script como root dentro do container."
        exit 1
    fi
}

validar_origem() {
    mkdir -p "$LOG_DIR"

    if [[ ! -d "$ORIGEM" ]]; then
        registrar_log "Diretório de origem não encontrado: $ORIGEM"
        echo "[ERRO] Pasta source não encontrada em $ORIGEM"
        exit 1
    fi

    if [[ ! -f "$ORIGEM/index.html" ]]; then
        registrar_log "index.html não encontrado em $ORIGEM"
        echo "[ERRO] index.html não encontrado na pasta source."
        exit 1
    fi
}

limpar_destino() {
    if [[ "$DESTINO" != "/var/www/html" ]]; then
        echo "[ERRO] Caminho de destino inseguro: $DESTINO"
        exit 1
    fi

    mkdir -p "$DESTINO"
    registrar_log "Limpando destino do deploy: $DESTINO"
    rm -rf "$DESTINO"/* "$DESTINO"/.[!.]* "$DESTINO"/..?* 2>/dev/null || true
}

publicar_site() {
    registrar_log "Copiando arquivos de $ORIGEM para $DESTINO"
    cp -r "$ORIGEM"/. "$DESTINO"/

    if [[ -f "$DESTINO/index.html" ]]; then
        registrar_log "Deploy concluído com sucesso. index.html publicado."
        echo "[OK] Deploy realizado com sucesso. Arquivos publicados:"
        find "$DESTINO" -maxdepth 3 -type f | sort
    else
        registrar_log "Falha no deploy. index.html não encontrado no destino."
        echo "[ERRO] Deploy falhou. index.html não encontrado em $DESTINO"
        exit 1
    fi
}

reiniciar_apache() {
    if command -v apache2ctl > /dev/null 2>&1; then
        apache2ctl start >> "$LOG_FILE" 2>&1 || apache2ctl graceful >> "$LOG_FILE" 2>&1 || true
        registrar_log "Comando de start/graceful do Apache executado."
    else
        registrar_log "Apache não instalado. Execute ./02_apache.sh para acessar o site."
        echo "[ALERTA] Apache não está instalado. Execute ./02_apache.sh antes de acessar no navegador."
    fi
}

validar_root
validar_origem
limpar_destino
publicar_site
reiniciar_apache
