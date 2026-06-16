#!/bin/bash

# Trabalho 03 - Tarefa 09
# Tema: Sistema para Videomonitoramento
# Objetivo: gerar relatório operacional automatizado do ambiente.

PROJETO="Trabalho 03 - Linux, Shell Script e Cloud Computing"
TEMA="Sistema para Videomonitoramento"
ALUNO="Pedro Henrique Scheidt"
BASE_DIR="/app/videomonitoramento"
LOG_DIR="/app/logs"
RELATORIO="$LOG_DIR/relatorio_execucao.txt"
BACKUP_DIR="/app/backups"
PUBLICACAO="/var/www/html"
USUARIO="camera_user"
GRUPO="videomonitoramento_ops"

status_apache() {
    if pgrep -x apache2 > /dev/null; then
        echo "Apache em execução"
    else
        echo "Apache parado ou não instalado"
    fi
}

gerar_relatorio() {
    mkdir -p "$LOG_DIR"

    {
        echo "============================================================"
        echo "$PROJETO"
        echo "Aluno: $ALUNO"
        echo "Instituição: Unidavi"
        echo "Tema: $TEMA"
        echo "Data/Hora: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "============================================================"
        echo
        echo "1. Espaço em disco"
        df -h
        echo
        echo "2. Uso dos diretórios do projeto"
        if [[ -d "$BASE_DIR" ]]; then
            du -h --max-depth=2 "$BASE_DIR" 2>/dev/null | sort -h
        else
            echo "Estrutura temática ainda não criada em $BASE_DIR"
        fi
        echo
        echo "3. Status do Apache"
        status_apache
        if command -v apache2 > /dev/null 2>&1; then
            apache2 -v
        fi
        echo
        echo "4. Últimos backups"
        ls -lhtr "$BACKUP_DIR" 2>/dev/null | tail -n 10 || echo "Nenhum backup encontrado."
        echo
        echo "5. Últimos logs"
        ls -lhtr "$LOG_DIR" 2>/dev/null | tail -n 15 || echo "Nenhum log encontrado."
        echo
        echo "6. Arquivos publicados no Apache"
        find "$PUBLICACAO" -maxdepth 3 -type f 2>/dev/null | sort || echo "Nenhum arquivo publicado."
        echo
        echo "7. Usuários, grupos e permissões principais"
        getent group "$GRUPO" || echo "Grupo $GRUPO não encontrado."
        id "$USUARIO" 2>/dev/null || echo "Usuário $USUARIO não encontrado."
        if [[ -d "$BASE_DIR" ]]; then
            ls -ld "$BASE_DIR" "$BASE_DIR"/* 2>/dev/null
        fi
        echo
        echo "8. Processos relacionados ao Apache"
        ps aux | grep -i apache | grep -v grep || echo "Nenhum processo Apache encontrado."
        echo
        echo "============================================================"
        echo "Fim do relatório operacional"
        echo "============================================================"
    } > "$RELATORIO"
}

exibir_relatorio() {
    echo "[OK] Relatório gerado em: $RELATORIO"
    cat "$RELATORIO"
}

gerar_relatorio
exibir_relatorio
