#!/bin/bash

# Trabalho 03 - Menu Principal
# Criado por: Pedro Henrique Scheidt
# Instituição: Unidavi
# Tema: Sistema para Videomonitoramento

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pausar() {
    echo
    read -r -p "Pressione ENTER para continuar..." _
}

cabecalho() {
    clear
    echo "Criado por: Pedro Henrique Scheidt"
    echo "Instituição: Unidavi"
    echo "Tema: Sistema para Videomonitoramento"
    echo "===== MENU DEVOPS CLOUD ====="
    echo "1 - Atualizar sistema"
    echo "2 - Instalar Apache"
    echo "3 - Criar estrutura do projeto"
    echo "4 - Realizar backup"
    echo "5 - Fazer deploy"
    echo "6 - Ver processos"
    echo "7 - Monitorar sistema"
    echo "8 - Configurar usuários e permissões"
    echo "9 - Gerar relatório"
    echo "0 - Sair"
    echo "============================="
}

executar_processos() {
    echo "===== GERENCIAMENTO DE PROCESSOS ====="
    echo "1 - Listar processos"
    echo "2 - Buscar processo por nome"
    echo "3 - Matar processo por PID"
    echo "0 - Voltar"
    read -r -p "Escolha uma opção: " opcao_proc

    case "$opcao_proc" in
        1)
            bash "$SCRIPT_DIR/06_processos.sh" listar
            ;;
        2)
            read -r -p "Informe o nome do processo: " nome
            bash "$SCRIPT_DIR/06_processos.sh" buscar "$nome"
            ;;
        3)
            read -r -p "Informe o PID: " pid
            bash "$SCRIPT_DIR/06_processos.sh" matar "$pid"
            ;;
        0)
            return
            ;;
        *)
            echo "[ERRO] Opção inválida."
            ;;
    esac
}

while true; do
    cabecalho
    read -r -p "Escolha uma opção: " opcao

    case "$opcao" in
        1)
            bash "$SCRIPT_DIR/01_update.sh"
            pausar
            ;;
        2)
            bash "$SCRIPT_DIR/02_apache.sh"
            pausar
            ;;
        3)
            bash "$SCRIPT_DIR/03_estrutura.sh"
            pausar
            ;;
        4)
            bash "$SCRIPT_DIR/04_backup.sh"
            pausar
            ;;
        5)
            bash "$SCRIPT_DIR/05_deploy.sh"
            pausar
            ;;
        6)
            executar_processos
            pausar
            ;;
        7)
            bash "$SCRIPT_DIR/07_monitoramento.sh"
            pausar
            ;;
        8)
            bash "$SCRIPT_DIR/08_usuarios_permissoes.sh"
            pausar
            ;;
        9)
            bash "$SCRIPT_DIR/09_relatorio.sh"
            pausar
            ;;
        0)
            echo "Saindo do menu."
            exit 0
            ;;
        *)
            echo "[ERRO] Opção inválida."
            pausar
            ;;
    esac
done
