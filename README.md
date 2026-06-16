# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno
Pedro Henrique Scheidt

## Instituição
Unidavi

## Tema
Sistema para videomonitoramento

## Descrição do Projeto
Este projeto simula a preparação operacional de um ambiente Linux utilizado por uma aplicação de videomonitoramento em cloud computing.

O cenário representa uma infraestrutura em que câmeras, alertas, gravações, logs e publicações web precisam ser organizados, monitorados, protegidos por permissões e mantidos por rotinas automatizadas em Shell Script.

O ambiente roda em container Ubuntu com Docker, utiliza Apache para publicar um site estático e possui scripts para atualização do sistema, instalação de serviços, criação de estrutura temática, backup, deploy, gerenciamento de processos, monitoramento, permissões e relatório operacional.

## Tecnologias Utilizadas
- Linux Ubuntu 24.04
- Docker
- Docker Compose
- Apache
- Shell Script
- ffmpeg
- GitHub
- DockerHub

## Estrutura do Projeto

```text
trabalho03-cloud-shell/
├── Dockerfile
├── docker-compose.yml
├── README.md
├── COMANDOS_ENTREGA.md
├── RELATORIO_GOOGLE_DOCS_MODELO.md
├── scripts/
│   ├── 01_update.sh
│   ├── 02_apache.sh
│   ├── 03_estrutura.sh
│   ├── 04_backup.sh
│   ├── 05_deploy.sh
│   ├── 06_processos.sh
│   ├── 07_monitoramento.sh
│   ├── 08_usuarios_permissoes.sh
│   ├── 09_relatorio.sh
│   └── menu.sh
├── source/
│   ├── index.html
│   ├── sobre.html
│   └── assets/
│       └── style.css
├── backups/
├── logs/
└── evidencias/
```

### Principais pastas

| Pasta | Finalidade |
|---|---|
| `scripts/` | Scripts Shell das tarefas obrigatórias e menu principal |
| `source/` | Site estático do sistema de videomonitoramento |
| `backups/` | Arquivos `.tar.gz` gerados pelo script de backup |
| `logs/` | Logs dos scripts e relatório operacional |
| `evidencias/` | Prints ou arquivos de evidência da execução |

## Como Executar o Projeto

Na máquina local, dentro da pasta do projeto, execute:

```bash
docker compose up -d --build
```

Entre no container:

```bash
docker exec -it trabalho03-linux bash
```

Dentro do container, acesse a pasta dos scripts:

```bash
cd /app/scripts
chmod +x *.sh
```

Execute o menu principal:

```bash
./menu.sh
```

## Sequência Recomendada de Execução

Dentro do container, execute nesta ordem:

```bash
cd /app/scripts
chmod +x *.sh
./01_update.sh
./02_apache.sh
./03_estrutura.sh
./04_backup.sh
./05_deploy.sh
./07_monitoramento.sh
./08_usuarios_permissoes.sh
./09_relatorio.sh
```

Também é possível executar pelo menu:

```bash
./menu.sh
```

## Como Acessar o Apache no Navegador

Após executar os scripts `02_apache.sh` e `05_deploy.sh`, acesse no navegador da máquina local:

```text
http://localhost:8080
```

A porta `8080` da máquina local está mapeada para a porta `80` do Apache dentro do container.

## Scripts Disponíveis

| Script | Descrição |
|---|---|
| `01_update.sh` | Atualiza os pacotes do sistema e registra log |
| `02_apache.sh` | Instala Apache, instala ffmpeg, inicia e valida o serviço |
| `03_estrutura.sh` | Cria a estrutura temática do videomonitoramento em `/app/videomonitoramento` |
| `04_backup.sh` | Gera backup `.tar.gz` da estrutura temática em `/app/backups` |
| `05_deploy.sh` | Publica os arquivos da pasta `source/` em `/var/www/html` |
| `06_processos.sh` | Lista, busca e encerra processos por PID informado |
| `07_monitoramento.sh` | Monitora CPU, memória, disco e status do Apache |
| `08_usuarios_permissoes.sh` | Cria grupo, usuário de sistema e aplica permissões seguras |
| `09_relatorio.sh` | Gera relatório operacional em `/app/logs/relatorio_execucao.txt` |
| `menu.sh` | Menu interativo para executar as principais rotinas |

## Exemplos de Execução Individual

```bash
./06_processos.sh listar
./06_processos.sh buscar apache
./06_processos.sh matar 1234
```

# DockerHub

Link da imagem publicada:

```text
https://hub.docker.com/r/pedrohs303/trabalho03-videomonitoramento
```

## Comandos para Publicar no DockerHub

```bash
docker login
docker build -t pedrohs303/trabalho03-videomonitoramento:latest .
docker push pedrohs303/trabalho03-videomonitoramento:latest
```

## Principais Dificuldades Encontradas

Durante a criação do ambiente, os principais pontos de atenção foram:

- Iniciar o Apache corretamente dentro de um container Ubuntu sem `systemd`.
- Evitar permissões excessivas como `chmod 777`.
- Criar scripts reaproveitáveis com funções, validações, logs e mensagens claras.
- Adaptar o ambiente ao tema de videomonitoramento, evitando diretórios genéricos.
- Organizar evidências para que o professor consiga validar a execução.

## Explicação Sobre Uso de IA

Foi utilizada IA generativa como apoio para estruturar o projeto, revisar a documentação e auxiliar na criação dos scripts Shell. 
