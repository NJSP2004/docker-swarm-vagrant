# Docker Swarm Cluster com Vagrant

Projeto desenvolvido como parte de um desafio da DIO para provisionar um cluster Docker Swarm local utilizando Vagrant e VirtualBox.

## Objetivo

Automatizar a criação de quatro máquinas virtuais Ubuntu, instalar o Docker Engine e configurar um cluster Docker Swarm com um nó manager e três workers.

## Arquitetura

| Nó | Endereço IP | Função |
|---|---|---|
| master | 192.168.56.10 | Swarm manager |
| node01 | 192.168.56.11 | Swarm worker |
| node02 | 192.168.56.12 | Swarm worker |
| node03 | 192.168.56.13 | Swarm worker |

Cada máquina está configurada com 1 vCPU e 1 GB de memória RAM, totalizando 4 vCPUs e 4 GB de RAM para as quatro VMs.

## Tecnologias

- Vagrant
- VirtualBox
- Ubuntu 22.04
- Docker Engine
- Docker Swarm
- Bash

## Estrutura do projeto

```text
docker-swarm-vagrant/
├── Vagrantfile
├── scripts/
│   ├── install-docker.sh
│   └── configure-swarm.sh
├── .gitignore
└── README.md
```

## Pré-requisitos

- Sistema operacional compatível com Vagrant e VirtualBox.
- Vagrant instalado.
- VirtualBox instalado e funcional.
- Recursos de hardware suficientes para executar quatro máquinas virtuais.
- Conexão com a internet para baixar a imagem Ubuntu e os pacotes do Docker.

## Como executar

Após instalar os pré-requisitos e clonar este repositório, entre no diretório do projeto e execute:

```bash
vagrant up --no-parallel
```

A opção `--no-parallel` solicita que as máquinas sejam inicializadas e provisionadas sequencialmente, permitindo que o manager seja configurado antes dos workers.

Para consultar o estado das máquinas:

```bash
vagrant status
```

Para verificar os nós registrados no cluster:

```bash
vagrant ssh master -c "docker node ls"
```

Para conferir o estado do Swarm no manager:

```bash
vagrant ssh master -c "docker info --format '{{.Swarm.LocalNodeState}}'"
```

O resultado esperado do último comando é `active`. Após o provisionamento completo, o comando `docker node ls` deverá mostrar o manager e os três workers.

## Segurança

O token de entrada dos workers é armazenado temporariamente no arquivo `.swarm-worker-token`, que está listado no `.gitignore`. Esse arquivo não deve ser enviado ao repositório.

## Validação e limitações

A sintaxe dos scripts Bash foi verificada com `bash -n`.

A execução integrada do Vagrant, a criação das máquinas virtuais, a instalação real do Docker e a formação do cluster ainda precisam ser testadas em um ambiente com Vagrant, VirtualBox e recursos suficientes.

Neste ambiente de desenvolvimento, a validação foi limitada à análise dos arquivos e à verificação sintática dos scripts Bash.

## Autor

Projeto acadêmico desenvolvido para fins de estudo de infraestrutura como código e orquestração de containers.
