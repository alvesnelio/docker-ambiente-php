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

### Roteiro de criação do ambiente

- [Passo a passo de criação caso deseja saber como tudo foi criado](roteiro-docker-compose.md).