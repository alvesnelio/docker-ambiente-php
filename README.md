Ambiente DOCKER com NGINX, PHP e MYSQL
===================================

> Um simples projeto de ambiente de desenvolvimento web com Docker, Nginx PHP e Mysql com o sistema operacional Ubuntu

## Requisitos

> Todos os requisitos necessário para que a aplicação funcione corretamente.

- Ubuntu:20.04-lts
- [Docker](https://docs.docker.com/engine/install/)
- [docker-compose](https://docs.docker.com/compose/install/)
  
## Serviços para composição do arquivo docker-compose

  - [Nginx](https://hub.docker.com/_/nginx)
    - Versão: `nginx:1.19.1` 
  - [PHP](https://hub.docker.com/_/php)
    - Versão: `php:7.3-fpm`
  - [Mysql](https://hub.docker.com/_/mysql)
    - Versão: `mysql:5.7`

### Passo a Passo para a construção deste docker-compose

> Para a construção deste ambiente foi realizado diversas ações durante a sua criação, segue embaixo um passo a passo.
</br>

- Crie um diretorio para a criação do seu ambiente de desenvolvimento com docker.
  - Comando: `mkdir -p ~/DEV/projetos/app-docker-php`
- Dentro deste diretorio vamos criar um arquivo [docker-compose.yml](https://docs.docker.com/compose/compose-file/) para a construção do nosso servidor web com `docker-compose`.
  - Comando 1: `cd ~/DEV/projetos/app-docker-php`
  - Comando 2: `touch docker-compose.yml`

- Abra este diretorio no seu editor de texto como `vscode`, `subleme`, `atom`, `netbens` ou `phpstorm`.
  - Comando via terminal para abrir no vscode: `code .`.
- Abra o arquivo `docker-compose.yml` e comece a escrever o seu ambiente web.

```
version: "3.7"
```

- Esta versão especifica qual versão do docker-compose esta sendo utilizado para a construção do `docker-compose.yml`
  - [docker-compose:version:3.7](https://docs.docker.com/compose/compose-file/compose-versioning/)
- Após a escrita da versão vamos começar a criação dos serviços do ambiente de desenvolvimento.

```
services:
  # nome do serviço criado
  web:

    # imagem baixada do docker-hub.
    image: nginx:1.19.1

    # Nome do container deste serviço.
    container_name: nginx-projeto-php 

    # Reinicialização automatica do container sempre que necessário.
    restart: always

    # Volumes mapeados de pastas do containers para dentro deste projeto.
    volumes:

      # Mapeamento do volume de execução do root deste projeto.
      - ./www:/www

      # Mapeamento da configuração do nginx-conf do container no nosso projeto.
      - ./docker/nginx/conf.d/app-docker-php.localhost.conf:/etc/nginx/conf.d/app-docker-php.localhost.conf

      # Mapeamento das pastas de logs do nginx do containers no nosso projeto.
      - ./docker/nginx/logs:/var/log/nginx/

    # Pasta de execução do nosso projeto no container.
    # Observação: Esta pasta foi maepada no root do volume "www" no arquivo de configuração do Nginx.
    working_dir: /www 

    # Porta de execução do nosso container.
    ports:
      - "80:80"
```

- Services são os containers que queremos executar na execução do nosso projeto `app-docker-php`
  - Conforme pode ser visto no codigo acima, todas as linhas tem um comentario acima dando uma breve explicação.
- Após a criação do serviço `web` que está relacionado ao servidor `nginx:1.19.1`, vamos criar o proximo serviço.

```
    # Links de vinculação de serviços, para que o serviço atual possa ter acesso ao outro serviço
    links:
      - php

  # Nome do serviço
  php:

    # imagem baixada do docker-hub.
    image: php:7.3-fpm

    # Nome do container deste serviço.
    container_name: php73-projeto-php

    # Mapeamento do volume de execução de leitura do PHP.
    volumes:
      - ./www:/www
```