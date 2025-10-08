FROM python:3.12-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y --no-install-recommends bash build-essential libpq-dev postgresql-client curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt /app/
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

FROM base AS runtime
ENV DJANGO_SETTINGS_MODULE=chan_platform.settings
WORKDIR /app
COPY . /app
RUN python -m compileall .
EXPOSE 8000
CMD ["bash", "-lc", "bash scripts/wait_for_db.sh ${DB_HOST:-db} ${DB_USER:-chan} && python manage.py collectstatic --noinput && python manage.py makemigrations --noinput && python manage.py migrate && if [ -n \"$DJANGO_SUPERUSER_USERNAME\" ]; then python manage.py createsuperuser --noinput || true; fi && python manage.py seed_demo || true && opentelemetry-instrument gunicorn chan_platform.asgi:application -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000 --workers 3 --timeout 120"]
