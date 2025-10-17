FROM python:3.12-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y --no-install-recommends bash build-essential libpq-dev postgresql-client curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt /app/
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

FROM base AS runtime
WORKDIR /app
COPY . /app
RUN python -m compileall .
CMD ["bash", "-lc", "bash scripts/wait_for_db.sh ${DB_HOST:-db} ${DB_USER:-chan} && python manage.py makemigrations --noinput && python manage.py migrate && opentelemetry-instrument celery -A chan_platform worker -l info"]
