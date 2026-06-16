#!/bin/bash

# Trabalho 03 - Tarefa 01
# Tema: Sistema para Videomonitoramento
# Objetivo: atualizar o ambiente Linux e registrar logs da execução.

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/01_update.log"

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

atualizar_sistema() {
    mkdir -p "$LOG_DIR"
    registrar_log "Iniciando atualização do sistema para o ambiente de videomonitoramento."

    if apt update >> "$LOG_FILE" 2>&1 && apt upgrade -y >> "$LOG_FILE" 2>&1; then
        registrar_log "Sistema atualizado com sucesso."
        echo "[OK] Sistema atualizado com sucesso. Log: $LOG_FILE"
    else
        registrar_log "Falha durante a atualização do sistema."
        echo "[ERRO] Falha durante a atualização. Verifique o log: $LOG_FILE"
        exit 1
    fi
}

validar_root
atualizar_sistema
