#!/bin/bash

# Trabalho 03 - Tarefa 04
# Tema: Sistema para Videomonitoramento
# Objetivo: gerar backup compactado da estrutura temática.

ORIGEM="/app/videomonitoramento"
DESTINO="/app/backups"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/04_backup.log"
DATA_HORA="$(date '+%Y-%m-%d_%H-%M-%S')"
ARQUIVO_BACKUP="$DESTINO/backup_videomonitoramento_${DATA_HORA}.tar.gz"

registrar_log() {
    local mensagem="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensagem" | tee -a "$LOG_FILE"
}

preparar_backup() {
    mkdir -p "$DESTINO" "$LOG_DIR"

    if [[ ! -d "$ORIGEM" ]]; then
        registrar_log "Diretório de origem não encontrado: $ORIGEM"
        echo "[ALERTA] Estrutura não encontrada. Execute primeiro: ./03_estrutura.sh"
        exit 1
    fi
}

gerar_backup() {
    registrar_log "Iniciando backup de $ORIGEM para $ARQUIVO_BACKUP"

    if tar -czf "$ARQUIVO_BACKUP" -C "$(dirname "$ORIGEM")" "$(basename "$ORIGEM")" >> "$LOG_FILE" 2>&1; then
        registrar_log "Backup gerado com sucesso: $ARQUIVO_BACKUP"
    else
        registrar_log "Falha ao gerar backup."
        echo "[ERRO] Falha ao gerar backup. Verifique o log: $LOG_FILE"
        exit 1
    fi
}

validar_backup() {
    if [[ -f "$ARQUIVO_BACKUP" && -s "$ARQUIVO_BACKUP" ]]; then
        echo "[OK] Backup criado com sucesso: $ARQUIVO_BACKUP"
        ls -lh "$ARQUIVO_BACKUP"
    else
        registrar_log "Backup não encontrado ou vazio após execução."
        echo "[ERRO] Backup não foi criado corretamente."
        exit 1
    fi
}

preparar_backup
gerar_backup
validar_backup
