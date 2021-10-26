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