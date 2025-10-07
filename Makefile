SHELL := /bin/bash

export COMPOSE := docker compose

.PHONY: up down logs migrate su test lint format openapi seed

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

test:
	$(COMPOSE) exec web pytest

lint:
	$(COMPOSE) exec web ruff check . && $(COMPOSE) exec web mypy --install-types --non-interactive apps

format:
	$(COMPOSE) exec web black . && $(COMPOSE) exec web ruff check . --fix

openapi:
	$(COMPOSE) exec web python manage.py spectacular --file docs/openapi.json

