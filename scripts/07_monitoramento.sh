#!/bin/bash

# Trabalho 03 - Tarefa 07
# Tema: Sistema para Videomonitoramento
# Objetivo: monitorar CPU, memória, disco e Apache.

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/07_monitoramento.log"
LIMITE_CPU=80
LIMITE_MEMORIA=80
LIMITE_DISCO=80

registrar_log() {
    local mensagem="$1"
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensagem" | tee -a "$LOG_FILE"
}

coletar_cpu() {
    top -bn1 | awk -F'id,' '/Cpu\(s\)|%Cpu/ { split($1, partes, ","); split(partes[length(partes)], valor, " "); printf("%.0f", 100 - valor[1]); exit }'
}

coletar_memoria() {
    free | awk '/Mem:/ { printf("%.0f", ($3/$2) * 100) }'
}

coletar_disco() {
    df /app | awk 'NR==2 { gsub("%", "", $5); print $5 }'
}

status_apache() {
    if pgrep -x apache2 > /dev/null; then
        echo "em_execucao"
    else
        echo "parado"
    fi
}

emitir_alertas() {
    local cpu="$1"
    local memoria="$2"
    local disco="$3"
    local apache="$4"

    if [[ -n "$cpu" && "$cpu" -ge "$LIMITE_CPU" ]]; then
        registrar_log "[ALERTA] Uso de CPU acima de ${LIMITE_CPU}%: ${cpu}%"
    else
        registrar_log "[OK] CPU dentro do limite: ${cpu}%"
    fi

    if [[ -n "$memoria" && "$memoria" -ge "$LIMITE_MEMORIA" ]]; then
        registrar_log "[ALERTA] Uso de memória acima de ${LIMITE_MEMORIA}%: ${memoria}%"
    else
        registrar_log "[OK] Memória dentro do limite: ${memoria}%"
    fi

    if [[ -n "$disco" && "$disco" -ge "$LIMITE_DISCO" ]]; then
        registrar_log "[ALERTA] Uso de disco acima de ${LIMITE_DISCO}%: ${disco}%"
    else
        registrar_log "[OK] Disco dentro do limite: ${disco}%"
    fi

    if [[ "$apache" == "em_execucao" ]]; then
        registrar_log "[OK] Apache em execução."
    else
        registrar_log "[ALERTA] Apache não está em execução."
    fi
}

monitorar_sistema() {
    local data_coleta
    local cpu
    local memoria
    local disco
    local apache

    data_coleta="$(date '+%Y-%m-%d %H:%M:%S')"
    cpu="$(coletar_cpu)"
    memoria="$(coletar_memoria)"
    disco="$(coletar_disco)"
    apache="$(status_apache)"

    echo "===== Monitoramento do Sistema de Videomonitoramento ====="
    echo "Data/Hora: $data_coleta"
    echo "CPU: ${cpu}%"
    echo "Memória RAM: ${memoria}%"
    echo "Disco /app: ${disco}%"
    echo "Apache: $apache"
    echo "=========================================================="

    emitir_alertas "$cpu" "$memoria" "$disco" "$apache"
}

monitorar_sistema
