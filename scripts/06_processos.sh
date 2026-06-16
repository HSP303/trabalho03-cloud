#!/bin/bash

# Trabalho 03 - Tarefa 06
# Tema: Sistema para Videomonitoramento
# Objetivo: listar, buscar e encerrar processos de forma controlada.

LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/06_processos.log"

registrar_log() {
    local mensagem="$1"
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensagem" | tee -a "$LOG_FILE" > /dev/null
}

listar_processos() {
    registrar_log "Listando processos ativos."
    echo "[INFO] Processos ativos no ambiente de videomonitoramento:"
    ps aux --sort=-%mem | head -n 15
}

buscar_processo() {
    local nome="$1"

    if [[ -z "$nome" ]]; then
        echo "[ERRO] Informe o nome do processo. Exemplo: ./06_processos.sh buscar apache"
        exit 1
    fi

    registrar_log "Buscando processo pelo nome: $nome"
    echo "[INFO] Resultado da busca por: $nome"
    ps aux | grep -i "$nome" | grep -v grep || echo "[ALERTA] Nenhum processo encontrado para: $nome"
}

matar_processo() {
    local pid="$1"

    if [[ -z "$pid" ]]; then
        echo "[ERRO] Informe o PID. Exemplo: ./06_processos.sh matar 1234"
        exit 1
    fi

    if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
        echo "[ERRO] PID inválido. Use apenas números."
        exit 1
    fi

    if [[ "$pid" -le 1 ]]; then
        echo "[ERRO] Por segurança, este script não encerra PID 0 ou 1."
        exit 1
    fi

    if ! ps -p "$pid" > /dev/null 2>&1; then
        echo "[ERRO] PID não encontrado: $pid"
        exit 1
    fi

    registrar_log "Encerrando processo PID $pid."
    kill "$pid"
    echo "[OK] Sinal de encerramento enviado para o PID $pid."
}

exibir_ajuda() {
    echo "Uso:"
    echo "  ./06_processos.sh listar"
    echo "  ./06_processos.sh buscar apache"
    echo "  ./06_processos.sh matar 1234"
}

case "$1" in
    listar)
        listar_processos
        ;;
    buscar)
        buscar_processo "$2"
        ;;
    matar)
        matar_processo "$2"
        ;;
    *)
        exibir_ajuda
        exit 1
        ;;
esac
