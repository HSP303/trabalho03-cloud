#!/bin/bash

# Trabalho 03 - Tarefa 03
# Tema: Sistema para Videomonitoramento
# Objetivo: criar estrutura temática para operação, dados, logs e publicação.

BASE_DIR="/app/videomonitoramento"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/03_estrutura.log"

registrar_log() {
    local mensagem="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensagem" | tee -a "$LOG_FILE"
}

remover_estrutura_antiga() {
    if [[ -d "$BASE_DIR" ]]; then
        if [[ "$BASE_DIR" == "/app/videomonitoramento" ]]; then
            registrar_log "Removendo estrutura antiga com segurança: $BASE_DIR"
            rm -rf "$BASE_DIR"
        else
            echo "[ERRO] Caminho inseguro para remoção: $BASE_DIR"
            exit 1
        fi
    fi
}

criar_diretorios() {
    mkdir -p "$LOG_DIR"
    registrar_log "Criando estrutura do sistema de videomonitoramento."

    mkdir -p \
        "$BASE_DIR/cameras" \
        "$BASE_DIR/gravacoes" \
        "$BASE_DIR/alertas" \
        "$BASE_DIR/dados" \
        "$BASE_DIR/configuracoes" \
        "$BASE_DIR/publicacao" \
        "$BASE_DIR/logs" \
        "$BASE_DIR/backups" \
        "$BASE_DIR/relatorios"

    registrar_log "Diretórios criados em $BASE_DIR."
}

criar_arquivos_iniciais() {
    cat > "$BASE_DIR/cameras/cameras.txt" <<ARQ
CAM01 - Entrada principal - ativa
CAM02 - Recepção - ativa
CAM03 - Estoque de gravações - em manutenção
ARQ

    cat > "$BASE_DIR/configuracoes/cameras.conf" <<ARQ
# Configuração simulada do sistema de videomonitoramento
retencao_gravacoes_dias=30
resolucao_padrao=1080p
alerta_movimento=true
ARQ

    cat > "$BASE_DIR/dados/status_sistema.csv" <<ARQ
data,camera,status
$(date '+%Y-%m-%d'),CAM01,online
$(date '+%Y-%m-%d'),CAM02,online
$(date '+%Y-%m-%d'),CAM03,manutencao
ARQ

    echo "Arquivo de alertas inicial do videomonitoramento" > "$BASE_DIR/alertas/alertas_iniciais.log"
    echo "Pasta de publicação do painel web de videomonitoramento" > "$BASE_DIR/publicacao/README_publicacao.txt"

    registrar_log "Arquivos iniciais criados."
}

exibir_resultado() {
    echo "[OK] Estrutura criada com sucesso em $BASE_DIR"
    find "$BASE_DIR" -maxdepth 2 -type d | sort
}

mkdir -p "$LOG_DIR"
remover_estrutura_antiga
criar_diretorios
criar_arquivos_iniciais
exibir_resultado
