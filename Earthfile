VERSION 0.6

ARG TAG='latest'
ARG DOCKER_IMAGE_NAME='ghcr.io/yothinix/earthly-thurstech'

lint:
  FROM DOCKERFILE .
  RUN flake8

test:
  FROM docker:20.10-dind

  COPY ./example ./example
  COPY docker-compose.env ./docker-compose.env
  COPY docker-compose.yml ./docker-compose.yml

  WITH DOCKER --compose docker-compose.yml
    RUN docker compose exec app python manage.py test
  END

migrate:
  FROM docker:20.10-dind

  COPY ./example ./example
  COPY docker-compose.env ./docker-compose.env
  COPY docker-compose.yml ./docker-compose.yml

  RUN apk update
  RUN apk add postgresql-client

  WITH DOCKER --compose docker-compose.yml --load app:latest=+build
    RUN while ! pg_isready --host=localhost --port=5432; do sleep 1; done ; \
      docker compose exec app python manage.py migrate
  END

build:
  FROM DOCKERFILE .
  SAVE IMAGE $DOCKER_IMAGE_NAME:$TAG

publish:
  FROM +build
  SAVE IMAGE --push $DOCKER_IMAGE_NAME:$TAG

release:
  BUILD +build
  BUILD +publish
