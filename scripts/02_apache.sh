#!/bin/bash

# Trabalho 03 - Tarefa 02
# Tema: Sistema para Videomonitoramento
# Objetivo: instalar Apache e ffmpeg, validar serviço e exibir versão.

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/02_apache.log"

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

instalar_apache() {
    mkdir -p "$LOG_DIR"
    registrar_log "Instalando Apache e ffmpeg para o ambiente de videomonitoramento."

    apt update >> "$LOG_FILE" 2>&1
    if apt install -y apache2 ffmpeg >> "$LOG_FILE" 2>&1; then
        registrar_log "Apache e ffmpeg instalados com sucesso."
        echo "[OK] Apache e ffmpeg instalados."
    else
        registrar_log "Falha ao instalar Apache ou ffmpeg."
        echo "[ERRO] Falha na instalação. Verifique o log: $LOG_FILE"
        exit 1
    fi
}

iniciar_apache() {
    echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
    a2enconf servername >> "$LOG_FILE" 2>&1 || true

    if apache2ctl start >> "$LOG_FILE" 2>&1 || apache2ctl graceful >> "$LOG_FILE" 2>&1; then
        registrar_log "Apache iniciado ou recarregado com sucesso."
        echo "[OK] Apache iniciado/recarregado."
    else
        registrar_log "Não foi possível iniciar o Apache."
        echo "[ALERTA] Apache instalado, mas não iniciou automaticamente. Verifique: apache2ctl start"
    fi
}

verificar_apache() {
    if command -v apache2 > /dev/null 2>&1; then
        registrar_log "Apache encontrado no sistema."
        echo "[OK] Apache está instalado."
    else
        registrar_log "Apache não encontrado após instalação."
        echo "[ERRO] Apache não foi encontrado."
        exit 1
    fi

    if pgrep -x apache2 > /dev/null; then
        registrar_log "Processo do Apache está em execução."
        echo "[OK] Apache em execução."
    else
        registrar_log "Processo do Apache não está em execução."
        echo "[ALERTA] Apache instalado, porém sem processo ativo."
    fi
}

versao_apache() {
    registrar_log "Coletando versão do Apache."
    apache2 -v | tee -a "$LOG_FILE"

    if command -v ffmpeg > /dev/null 2>&1; then
        echo "[OK] Pacote complementar ffmpeg instalado para tratamento de vídeo."
        ffmpeg -version | head -n 1 | tee -a "$LOG_FILE"
    fi
}

validar_root
instalar_apache
iniciar_apache
verificar_apache
versao_apache
