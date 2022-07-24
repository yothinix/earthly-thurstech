FROM python:3.8

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN echo "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y postgresql-client-13

COPY ./compose/app/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV APPLICATION_ROOT /app
RUN mkdir $APPLICATION_ROOT
RUN python -m pip install poetry

COPY pyproject.toml poetry.lock /

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi

COPY ./example $APPLICATION_ROOT
WORKDIR $APPLICATION_ROOT