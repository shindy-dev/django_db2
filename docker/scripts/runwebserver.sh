#!/bin/bash

source /root/.bashrc
conda activate django
python manage.py makemigrations
python manage.py migrate
cd /home/dev/github/shindjango
python manage.py runserver 0.0.0.0:8000