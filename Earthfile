VERSION 0.6

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

build:
  FROM DOCKERFILE .
  SAVE ARTIFACT ./build/app

publish:
  FROM +build
  ARG TAG='latest'
  ARG DOCKER_IMAGE_NAME='ghcr.io/yothinix/earthly-thurstech'
  SAVE IMAGE --push  $DOCKER_IMAGE_NAME:$TAG

release:
  BUILD +build
  BUILD +publish
