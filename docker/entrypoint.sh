#!/usr/bin/env bash
set -euo pipefail

DB_HOST=${DB_HOST:-mysql}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER:-root}
DB_PASSWORD=${DB_PASSWORD:-admin}

# Espera por socket TCP primero (más robusto si mysqladmin falla)
until nc -z "$DB_HOST" "$DB_PORT" >/dev/null 2>&1; do
  echo "Esperando MySQL (TCP ${DB_HOST}:${DB_PORT})..."
  sleep 2
done

# Verifica credenciales cuando el puerto está abierto
for i in {1..20}; do
  if mysqladmin ping -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" --silent; then
    break
  fi
  echo "Esperando MySQL (auth)..."
  sleep 2
done
echo "MySQL está listo"
# Crea la base si no existe (útil cuando el volumen ya existía)
DB_NAME_CREATE=${MYSQL_DB:-${DB_NAME:-final_analisis}}
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME_CREATE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" || true
python manage.py makemigrations --noinput || true
python manage.py migrate --noinput
python manage.py collectstatic --noinput || true
if [ -n "${DJANGO_SUPERUSER_EMAIL:-}" ] && [ -n "${DJANGO_SUPERUSER_USERNAME:-}" ] && [ -n "${DJANGO_SUPERUSER_PASSWORD:-}" ]; then
  python - <<'PY'
import os, django
os.environ.setdefault('DJANGO_SETTINGS_MODULE','core.settings')
django.setup()
from django.contrib.auth import get_user_model
U=get_user_model(); u=os.environ['DJANGO_SUPERUSER_USERNAME']; e=os.environ['DJANGO_SUPERUSER_EMAIL']; p=os.environ['DJANGO_SUPERUSER_PASSWORD']
if not U.objects.filter(username=u).exists():
    U.objects.create_superuser(username=u,email=e,password=p)
    print('Superusuario creado')
else:
    print('Superusuario ya existe')
PY
fi
if [ "${ENV:-dev}" = "dev" ]; then
  python manage.py seed_demo || true
fi
python manage.py runserver 0.0.0.0:8000
