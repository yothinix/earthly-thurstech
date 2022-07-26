all: migrate lint test validate

runserver:
	docker compose up

run_daemon:
	docker compose up -d

test: run_daemon
	docker compose exec app python manage.py test

lint:
	poetry run flake8 example

migrate: run_daemon
	docker compose exec app python manage.py migrate

clean:
	docker compose down --volumes

validate: run_daemon
	docker compose exec app curl -I --fail localhost:8000/ping/
