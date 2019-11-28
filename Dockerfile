FROM python:slim-stretch

ENV PIP_DISABLE_PIP_VERSION_CHECK=on \
    PYTHONUNBUFFERED=1

RUN pip install -U pip poetry
RUN poetry config settings.virtualenvs.create false

# no-cache cleaning is intentional to speed up usage, we only need to keep the production image small
RUN apt-get update && apt-get install -qy gcc


WORKDIR /code/
ADD . /code
ADD etc/ /code/etc/
COPY etc/wait-for-it.sh /code/etc/

RUN poetry config settings.virtualenvs.create false
ADD pyproject.toml poetry.lock /code/
RUN poetry install --no-interaction --ansi

CMD ./etc/wait-for-it.sh elasticsearch:9200 -t 60 -- ./etc/wait-for-it.sh db:5432 -t 60 -- python manage.py runserver 0.0.0.0:8000
