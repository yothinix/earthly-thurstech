DOCKER_IMAGE_NAME = ghcr.io/yothinix/earthly-thurstech
HEALTHCHECK_URL = localhost:8000/ping/

run:
	docker compose up

run_daemon:
	docker compose up -d

test: run_daemon
	docker compose exec app python manage.py test

lint:
	docker compose exec app flake8

migrate: run_daemon
	docker compose exec app python manage.py migrate

clean:
	docker compose down --volumes

validate: run_daemon
	docker compose exec app curl -I --fail ${HEALTHCHECK_URL}

build:
	docker build --no-cache -t ${DOCKER_IMAGE_NAME} .

publish:
	docker push ${DOCKER_IMAGE_NAME}:latest

verify: migrate lint test validate
release: build publish

all: verify release
