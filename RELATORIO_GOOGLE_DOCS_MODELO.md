# Relatório Final - Trabalho 03

## Aluno
Pedro Henrique Scheidt

## Instituição
Unidavi

## Tema
Sistema para videomonitoramento

## 1. Contextualização

Este trabalho apresenta a criação de um ambiente Linux containerizado para simular rotinas operacionais de uma aplicação de videomonitoramento em cloud computing. O ambiente foi desenvolvido com Docker, Ubuntu, Apache e Shell Script, permitindo automatizar tarefas comuns de administração Linux.

O tema foi aplicado em nomes de diretórios, arquivos, usuários, grupos, logs, site estático e relatório operacional. A estrutura simula uma aplicação que possui câmeras, gravações, alertas, configurações, dados, backups e publicação web.

## 2. Tecnologias Utilizadas

- Ubuntu 24.04
- Docker
- Docker Compose
- Apache
- Shell Script
- ffmpeg
- GitHub
- DockerHub

## 3. Estrutura do Projeto

O repositório foi organizado com Dockerfile, docker-compose, scripts, site estático, backups, logs e evidências. Os scripts ficam na pasta `scripts/`, o site estático em `source/`, os backups em `backups/`, os logs em `logs/` e as evidências em `evidencias/`.

## 4. Funcionamento dos Scripts

### 01_update.sh
Atualiza o sistema operacional com `apt update` e `apt upgrade -y`, registrando o resultado em log.

### 02_apache.sh
Instala o Apache e o ffmpeg, inicia o Apache, valida a instalação e exibe a versão do serviço.

### 03_estrutura.sh
Cria a estrutura temática em `/app/videomonitoramento`, com diretórios para câmeras, gravações, alertas, dados, configurações, publicação, logs, backups e relatórios.

### 04_backup.sh
Gera um arquivo `.tar.gz` da estrutura de videomonitoramento, incluindo data e hora no nome do backup.

### 05_deploy.sh
Limpa o diretório `/var/www/html` e copia os arquivos estáticos da pasta `source/` para o Apache.

### 06_processos.sh
Permite listar processos, buscar processos por nome e encerrar um processo por PID informado.

### 07_monitoramento.sh
Coleta uso de CPU, memória, disco e status do Apache, emitindo alertas quando algum limite é ultrapassado.

### 08_usuarios_permissoes.sh
Cria o grupo `videomonitoramento_ops`, o usuário de sistema `camera_user` e aplica permissões seguras nos diretórios do projeto.

### 09_relatorio.sh
Gera o relatório operacional em `/app/logs/relatorio_execucao.txt`, com informações de disco, diretórios, Apache, backups, logs, arquivos publicados, usuários e permissões.

### menu.sh
Integra as principais rotinas em um menu interativo.

## 5. Evidências

Inserir aqui os prints ou arquivos da pasta `evidencias/`, demonstrando:

- Container em execução.
- Volumes configurados.
- Scripts com permissão de execução.
- Atualização do sistema.
- Apache instalado e validado.
- Estrutura de diretórios criada.
- Backup gerado.
- Deploy publicado.
- Site acessível no navegador.
- Monitoramento do sistema.
- Usuários e permissões.
- Relatório final.
- Imagem publicada no DockerHub.

## 6. Links de Entrega

Repositório GitHub:

```text
INSERIR_LINK_DO_GITHUB
```

Imagem DockerHub:

```text
INSERIR_LINK_DO_DOCKERHUB
```

## 7. Dificuldades Encontradas

As principais dificuldades foram iniciar e validar o Apache dentro de um container Ubuntu, manter permissões seguras sem utilizar `chmod 777`, organizar scripts com funções e logs e adaptar a estrutura ao tema de videomonitoramento.

## 8. Uso de IA

Foi utilizada IA generativa como apoio para estruturar o projeto, revisar os scripts e montar a documentação.

## 9. Conclusão

O trabalho permitiu simular rotinas reais de DevOps e administração Linux em ambiente cloud, com uso de Docker, Apache, Shell Script, permissões, deploy, backup, monitoramento, logs e documentação técnica. A solução ficou alinhada ao tema de videomonitoramento e pode ser executada pelo professor seguindo as instruções do README.
