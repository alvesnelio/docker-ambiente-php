# Passo a Passo para a construção deste docker-compose

> Para a construção deste ambiente foi realizado diversas ações durante a sua criação, segue embaixo um passo a passo.
</br>

- Crie um diretorio para a criação do seu ambiente de desenvolvimento com docker.
  - Comando: `mkdir -p ~/DEV/projetos/app-docker-php`
- Dentro deste diretorio vamos criar um arquivo [docker-compose.yml](https://docs.docker.com/compose/compose-file/) para a construção do nosso servidor web com `docker-compose`.
  - Comando 1: `cd ~/DEV/projetos/app-docker-php`
  - Comando 2: `touch docker-compose.yml`

- Abra este diretorio no seu editor de texto como `VSCode`, `Sublime Text`, `Atom`, `Netbens` ou `PhpStorm`.
  - Comando via terminal para abrir no vscode: `code .`.
- Abra o arquivo `docker-compose.yml` e comece a escrever o seu ambiente web.

```
version: "3.7"
```

- Esta versão especifica qual versão do docker-compose esta sendo utilizado para a construção do `docker-compose.yml`
  - [docker-compose:version:3.7](https://docs.docker.com/compose/compose-file/compose-versioning/)
- Após a escrita da versão vamos começar a criação dos serviços do ambiente de desenvolvimento começando pelo `nginx`.

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
- Conforme o codigo acima, foi criado um volume do arquivo de configuração do nginx, vamos criar ele.
  - Dentro da pasta do projeto, vamos criar um novo diretorio chamado `conf.d`.
  - Comando 1: `mkdir -p docker/nginx/conf.d`
- Após a criação do diretorio `docker/nginx/conf.d` no nosso projeto, vamos criar o arquivo de configuração do nginx.
  - Comando 1: `touch docker/nginx/conf.d/app-docker-php.localhost.conf`
    - Este arquivo foi criado com este nome apenas pelo motivo de este ser o host adicionado nos hosts `etc/hosts`
  - Abra o arquivo `app-docker-php.localhost.conf` no seu editor de texto e adicione os seguintes codigos.
  
```
server{
    listen  80;

    server_name app-docker-php.localhost;

    root /www;
    index index.html index.php;

    location / {
        try_files $uri /index.html;
        index index.html;
    }

    error_log /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
}
```

- Pode ser observado no codigo acima que ele foi configurado para o location indexar o arquivo `index.html`.
- Após a criação do arquivo `app-docker-php.localhost.conf`, vamos criar o diretorio `www` na raiz do projeto.
  - Comando 1: `mkdir www`
- Após a criação do diretorio, vamos criar um arquivo `index.html` com uma configuração bem simples.
  - Comando 1: `touch www/index.html`

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

- Após a criação do serviço `web` que está relacionado ao servidor `nginx:1.19.1`, vamos criar o serviço `php`.

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

- Após a criação do serviço `php` que está relacionado com o serviço `php:7.3-fpm`, vamos criar o serviço `mysql`.

```
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