# Passo a Passo para a construção deste docker-compose

> Para a construção deste ambiente foi realizado diversas ações durante a sua criação, segue embaixo um passo a passo.
</br>

- Crie um diretorio para a criação do seu ambiente de desenvolvimento com docker.
  - Comando: `mkdir -p ~/DEV/projetos/app-docker-php`
- Dentro deste diretorio vamos criar um arquivo [docker-compose.yml](https://docs.docker.com/compose/compose-file/) para a construção do nosso servidor web com `docker-compose`.
  - __Comando 1__: `cd ~/DEV/projetos/app-docker-php`.
  - __Comando 2__: `touch docker-compose.yml`.

- Abra este diretorio com seu editor de texto `VSCode`, `Sublime Text`, `Atom`, `Netbens` ou `PhpStorm`.
  - Comando via terminal para abrir no *vscode*: `code .`.
- Abra o arquivo `docker-compose.yml` e comece a escrever o seu ambiente web.

```
version: "3.7"
```

- Esta versão especifica qual versão do docker-compose esta sendo utilizado para a construção do `docker-compose.yml`
  - [docker-compose:version:3.7](https://docs.docker.com/compose/compose-file/compose-versioning/)
- Após a definição da versão, iremos iniciar a criação dos nossos serviços do ambiente de desenvolvimento começando pelo `nginx`.

```
services:
  # nome do serviço criado.
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
      - ./docker/nginx/conf.d/app-docker-php.conf:/etc/nginx/conf.d/app-docker-php.conf

      # Mapeamento das pastas de logs do nginx do containers no nosso projeto.
      - ./docker/nginx/logs:/var/log/nginx/

    # Pasta de execução do nosso projeto no container.
    # Observação: Esta pasta foi maepada no root do volume "www" no arquivo de configuração do Nginx.
    working_dir: /www 

    # Porta de execução do nosso container.
    ports:
      - "80:80"
```

- Services são os containers que queremos executar na execução do nosso projeto `app-docker-php`.
  - Conforme pode ser visto no codigo acima, todas as linhas tem um comentario acima dando uma breve explicação.
- Conforme o codigo acima, pode ser observado que foi criado alguns volumes do arquivo de configuração do nginx, agora iremos criar eles.
  - *Dentro da pasta do projeto, vamos criar um novo diretorio chamado `conf.d`.*
  - __Comando 1__: `mkdir -p docker/nginx/conf.d`.
  - __Comando 2__: `mkdir -p docker/nginx/logs`.
- Após a criação dos diretorios *`conf.d`* e *`logs`* de nossos serviços, vamos criar os arquivos que foram mapeados nos volumes.
  - __Comando 1__: `touch docker/nginx/conf.d/app-docker-php.conf`.
    - *Este arquivo foi criado com este nome apenas pelo motivo de este ser o host adicionado nos hosts `etc/hosts`*.
  - __Comando 2__: `touch docker/nginx/logs/access.log`.
  - __Comando 3__: `touch docker/nginx/logs/error.log`.
  - Abra o arquivo `app-docker-php.conf` no seu editor de texto e adicione os seguintes codigos.
  
```
server{
    listen  80;

    server_name app-docker-php;

    root /www;
    index index.html;

    location / {
        try_files $uri /index.html;
        index index.html;
    }

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
}
```

- Explicação do codigo `app-docker-php.conf`.
  - *`server`*: tag de abertura do nosso servidor nginx.
  - *`listen 80`*: faz referencia a porta que vai ser escutada pelo nosso servidor nginx.
  - *`server name app-docker-php`*: nome do nosso servidor que iria carregar estas configurações.
  - *`root /www`*: Diretorio raiz do nosso host que foi mapeado no volume do `docker-compose.yml`.
  - *`index index.html`*: arquivos indexados para leitura no nosso `server_name`.
  - *`location /{}`*: São usados para definir como o Nginx deve responder à requisições à diferentes recursos e URIs.
  - *`error_log`*: Local de registro do log que foi mapeado no volume do `docker-compose.yml`
  - *`access_log`*: Local de registro do log que foi mapeado no volume do `docker-compose.yml`
- Após a criação do arquivo `app-docker-php.conf`, vamos criar o diretorio `www` na raiz do projeto.
  - __Comando 1__: `~/DEV/projetos/app-docker-php`.
  - __Comando 2__: `mkdir www`
- Após a criação do diretorio, vamos criar um arquivo `index.html` com uma configuração bem simples.
  - __Comando 1__: `touch www/index.html`

```
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ola Mundo Docker Compose</title>
    </head>
    <body>
        <h1 align="center">Ola Mundo Docker Compose - Nginx - PHP 7.3 - MySQL</h1>
    </body>
</html>
```

- Após a criaçãdo do arquivo `index.html` vamos criar o nosso host local.
- Editar o arquivo de hosts do nosso ubuntu `/etc/hosts`.
  - __Comando 1__: `sudo nano /etc/hosts`.
    - Adicione a seguinte linha nos seus hosts `127.0.0.1   app-docker-php`.
- Agora que criamos o host local, vamos construir os serviços do docker.

</br> 

> Para facilitar o nosso trabalho, vamos criar um arquivo `Makefile` na raiz do projeto.
- Execute os comandos abaixo
  - __Comando 1__: `cd ~/DEV/projetos/app-docker-php/`
  - __Comando 2__: `touch ~/DEV/projetos/app-docker-php/Makefile`
- Abra o arquivo `Makefile` e escreva os codigos abaixo no mesmo.

```
SHELL := /bin/bash

docker-build:
	docker-compose -f ./docker-compose.yml up --build;
.PHONY: docker-build

docker-up:
	docker-compose -f ./docker-compose.yml up -d;
.PHONY: docker-up

docker-down:
	docker-compose -f ./docker-compose.yml down;
.PHONY: docker-down
```

- Explicação dos comandos do arquivo `Makefile`
  - __Comando 1__: `make docker-build`.
    - Contruir o container com os novos serviços do docker-compose.
  - __Comando 2__: `make docker-up`.
    - Levantar os serviços dos containers.
  - __Comando 3__: `make docker-down`.
    - Derrubar os serviços dos containers.
- Após a criação do `Makefile` vamos construir o container `web`
  - __Comando 1__: `make docker-build`
    - Após a construção do container `web` abra o seu navegador de internet e acesse o host que foi adicionado no `/etc/hosts`
    - __URL Projeto__: [http://app-docker-php/](http://app-docker-php/)
- Como pode ser visto, a aplicação abriu corretamenta no nosso host com um arquivo HTML.

</br>

- Após a criação do serviço `web` que está relacionado ao servidor `nginx:1.19.1`, vamos criar o nosso serviço `php`.
- No seu editor de arquivos, vamos editar o `docker-compose.yml` adicionando os seguintes codigos.

```
    # Links de vinculação de serviços, para que o serviço atual possa ter acesso ao outro serviço.
    links:
      - php

  # Nome do serviço.
  php:

    # imagem baixada do docker-hub.
    image: php:7.3-fpm

    # Nome do container deste serviço.
    container_name: php73-projeto-php

    # Mapeamento do volume de execução de leitura do PHP.
    volumes:
      - ./www:/www
```
- Após a adição do codigo acima, vamos criar um arquivo `.php` apartir do arquivo `.html` ja existente.
  - __Comando 1__: `cd ~/DEV/projetos/app-docker-php/`
  - __Comando 2__: `cp www/index.html www/index.php`
  - __Comando 3__: `rm -f www/index.html`
- Como pode ser vistos nos comandos acima, primeiro acessamos o diretorio raiz do nosso projeto, depois realizamos uma copia do `index.html` em um arquivo `index.php` e removemos o arquivo `index.html`.
- Agora vamos adicionar um `phpinfo()` no nosso arquivo `.php`.
- Abaixo do elemento `HTML <h1>...</h1>` adicione o seguinte trecho de codigo.

```
<?php
    echo phpinfo();
?>
```
- Após a adição deste codigo no arquivo `index.php`, vamos derrubar o container.
  - No terminal do seu computador, aperte os seguintes botões no seu teclado `ctrl + c`.
    - __Comando 1__: `ctrl + c`
- Após o desligamento do container, vamos configurar nosso arquivo `app-docker-php.conf` no nosso editor de texto com os seguintes dados.

```
server{
    listen  80;
    server_name app-docker-php.localhost;
    root /www;
    index index.html index.php;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
}
```

- Explicação do codigo `app-docker-php.conf`.
  - *`server;`*: tag de abertura do nosso servidor nginx.
  - *`listen 80;`*: faz referencia a porta que vai ser escutada pelo nosso servidor nginx.
  - *`server name app-docker-php;`*: nome do nosso servidor que iria carregar estas configurações.
  - *`root /www;`*: Diretorio raiz do nosso host que foi mapeado no volume do `docker-compose.yml`.
  - *`index index.html index.php;`*: Prioridade dos arquivos a serem indexados para leitura no nosso `server_name`.
  - *`location ~ \.php$ }`*: são usados para definir como o Nginx deve responder à requisições à diferentes recursos e URIs.
    - Com o parametro `~\`, as localizações serão interpretada como uma expressão regular case-sensitive.
    - *`try_files`*: [Verifica a existência de arquivos na ordem especificada.](http://nginx.org/en/docs/http/ngx_http_core_module.html#try_files)
    - *`fastcgi_split_path_info`*: [Define uma expressão regular.](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_split_path_info)
    - *`fastcgi_pass`*: [Define o endereço de um servidor.](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass)
    - *`fastcgi_index`*: [Define um nome de arquivo que será anexado após um URI que termina com uma barra.](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_index)
    - *``*:
    - 
  - *`error_log`*: Local de registro do log que foi mapeado no volume do `docker-compose.yml`
  - *`access_log`*: Local de registro do log que foi mapeado no volume do `docker-compose.yml`

- Após a alteração do arquivo `app-docker-php.conf`, vamos reconstruir nosso container.
  - __Comando 1__: `make docker-build`.
  - Acesse o site novamente no seu navegador e veja se está exibindo a tela do `phpinfo()`.
    - [http://app-docker-php](app-docker-php) - Se estiver exibindo a tela, significa que a criação do serviço PHP ocorreu tudo certo.

</br>
- Após a criação do serviço `php` que está relacionado com o serviço `php:7.3-fpm`, vamos criar o serviço `mysql`.
- No arquivo `docker-compose.yml` vamos adicionar o codigo abaixo no service.

```
    links:
      - db

  # Nome do serviço.
  db:
    
    # imagem baixada do docker-hub
    image: mysql:5.7
    
    # Nome do container deste servoço
    container_name: mysql-projeto-php

    # Variaveis de configuração deste serviço conforme a documentação do docker-hub
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: teste
```

- Após a adição deste serviço no nosso `docker-composer.yml`, vamos derrubar os nossos serviços e os criar novamente.
  - No terminal aperte os botões do teclado `CTRL +C` caso você tenha levantado os serviços com `make docker-build`.
  - Após derrubar o container, vamos levantar ele novamente para que ele seja executado com o serviço de banco de dados.
  - __Comando 1__: `make docker-build`.

</br>

- Para checar se tudo foi criado corretamente vamos executar o acesso ao contaier do mysql no nosso proprio terminal.
  - No nosso terminal vamos executar um `docker container exec`.
    - __Comando 1:__ `docker container exec -it mysql-projeto-php mysql -u root -p`
      - *Senha*: Senha configura no nosso docker-compose.yml serviço mysql `MYSQL_ROOT_PASSWORD`.
    - __Comando 2:__ `show databases;`
    - Se listar as bases de dados, significa que a instalação do serviço ocorreu com sucesso.