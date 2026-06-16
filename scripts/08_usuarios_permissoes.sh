#!/bin/bash

# Trabalho 03 - Tarefa 08
# Tema: Sistema para Videomonitoramento
# Objetivo: criar grupo, usuário de sistema e aplicar permissões seguras.

GRUPO="videomonitoramento_ops"
USUARIO="camera_user"
BASE_DIR="/app/videomonitoramento"
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/08_usuarios_permissoes.log"

registrar_log() {
    local mensagem="$1"
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $mensagem" | tee -a "$LOG_FILE"
}

validar_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "[ERRO] Execute este script como root dentro do container."
        exit 1
    fi
}

preparar_diretorios() {
    if [[ ! -d "$BASE_DIR" ]]; then
        registrar_log "Estrutura temática não encontrada. Criando diretórios básicos."
        mkdir -p "$BASE_DIR/gravacoes" "$BASE_DIR/alertas" "$BASE_DIR/dados" "$BASE_DIR/publicacao" "$BASE_DIR/logs" "$BASE_DIR/backups"
    fi
}

criar_grupo() {
    if getent group "$GRUPO" > /dev/null; then
        registrar_log "Grupo já existe: $GRUPO"
        echo "[OK] Grupo já existente: $GRUPO"
    else
        groupadd "$GRUPO"
        registrar_log "Grupo criado: $GRUPO"
        echo "[OK] Grupo criado: $GRUPO"
    fi
}

criar_usuario() {
    if id "$USUARIO" > /dev/null 2>&1; then
        registrar_log "Usuário já existe: $USUARIO"
        echo "[OK] Usuário já existente: $USUARIO"
    else
        useradd -r -m -g "$GRUPO" -s /usr/sbin/nologin "$USUARIO"
        registrar_log "Usuário de sistema criado: $USUARIO"
        echo "[OK] Usuário de sistema criado: $USUARIO"
    fi
}

aplicar_permissoes() {
    chown -R "$USUARIO:$GRUPO" "$BASE_DIR/gravacoes" "$BASE_DIR/alertas" "$BASE_DIR/dados" "$BASE_DIR/backups"
    chmod 750 "$BASE_DIR/gravacoes" "$BASE_DIR/alertas" "$BASE_DIR/dados" "$BASE_DIR/backups"

    chown -R root:"$GRUPO" "$BASE_DIR/publicacao" "$BASE_DIR/logs"
    chmod 755 "$BASE_DIR/publicacao"
    chmod 750 "$BASE_DIR/logs"

    registrar_log "Permissões aplicadas sem uso de chmod 777."
    echo "[OK] Permissões configuradas com segurança."
    echo "[INFO] Diretórios principais:"
    ls -ld "$BASE_DIR" "$BASE_DIR/gravacoes" "$BASE_DIR/alertas" "$BASE_DIR/dados" "$BASE_DIR/publicacao" "$BASE_DIR/logs" "$BASE_DIR/backups"
}

validar_root
preparar_diretorios
criar_grupo
criar_usuario
aplicar_permissoes
