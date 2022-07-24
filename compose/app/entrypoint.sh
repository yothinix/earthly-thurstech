#!/usr/bin/env bash

cd $APPLICATION_ROOT
python manage.py migrate --noinput
python manage.py runserver 0.0.0.0:8000