SHELL := /bin/bash

# Grupo #6: utilidades de desarrollo (Docker Compose)
export COMPOSE := docker compose

.PHONY: up down logs migrate su seed lint format

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down -v

logs:
	$(COMPOSE) logs -f --tail=200

migrate:
	$(COMPOSE) exec web python manage.py migrate

su:
	$(COMPOSE) exec web python manage.py createsuperuser

seed:
	$(COMPOSE) exec web python manage.py seed_demo

lint:
	$(COMPOSE) exec web ruff check .

format:
	$(COMPOSE) exec web ruff check . --fix
