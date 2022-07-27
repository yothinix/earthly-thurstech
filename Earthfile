VERSION 0.6

ARG TAG='latest'
ARG DOCKER_IMAGE_NAME='ghcr.io/yothinix/earthly-thurstech'

lint:
  FROM +build
  RUN flake8

docker-compose:
  FROM docker:20.10-dind

  COPY ./example ./example
  COPY docker-compose.env ./docker-compose.env
  COPY docker-compose.yml ./docker-compose.yml

  RUN apk update
  RUN apk add postgresql-client curl

test:
  FROM +docker-compose

  WITH DOCKER --compose docker-compose.yml --load app:latest=+build
    RUN while ! pg_isready --host=localhost --port=5432; do sleep 1; done ; \
      docker compose exec app python manage.py test
  END

migrate:
  FROM +docker-compose

  WITH DOCKER --compose docker-compose.yml --load app:latest=+build
    RUN while ! pg_isready --host=localhost --port=5432; do sleep 1; done ; \
      docker compose exec app python manage.py migrate
  END

validate:
  FROM +docker-compose
  ARG HEALTHCHECK_URL='http://localhost:8000/ping/'

  WITH DOCKER --compose docker-compose.yml --load app:latest=+build
    RUN while ! pg_isready --host=localhost --port=5432; do sleep 1; done ; \
      while ! curl -I --fail $HEALTHCHECK_URL; do sleep 1; done
  END

build:
  FROM python:3.8

  LABEL org.opencontainers.image.source https://github.com/yothinix/earthly-thurstech

  ENV PYTHONDONTWRITEBYTECODE 1
  ENV PYTHONUNBUFFERED 1

  RUN echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y postgresql-client-13

  COPY ./entrypoint.sh /entrypoint.sh
  RUN chmod +x /entrypoint.sh

  ENV APPLICATION_ROOT /app
  RUN mkdir $APPLICATION_ROOT
  RUN python -m pip install poetry

  COPY pyproject.toml poetry.lock /

  RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

  COPY ./example $APPLICATION_ROOT
  WORKDIR $APPLICATION_ROOT

  SAVE IMAGE $DOCKER_IMAGE_NAME:$TAG

publish:
  FROM +build
  SAVE IMAGE --push $DOCKER_IMAGE_NAME:$TAG

release:
  BUILD +build
  BUILD +publish

verify:
  BUILD +migrate
  BUILD +lint
  BUILD +test
  BUILD +validate

all:
  BUILD +verify
  BUILD +release
