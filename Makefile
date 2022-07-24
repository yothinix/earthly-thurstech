all: migrate lint test

runserver:
	docker compose up

test:
	docker compose exec app python manage.py test

lint:
	poetry run flake8 example

migrate:
	docker compose exec app python manage.py migrate
