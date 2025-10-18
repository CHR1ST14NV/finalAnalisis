#!/usr/bin/env bash
set -euo pipefail
until mysqladmin ping -h"${DB_HOST:-mysql}" -P"${DB_PORT:-3306}" -u"${DB_USER:-root}" -p"${DB_PASSWORD:-admin}" --silent; do
  echo "Esperando MySQL..."
  sleep 2
done
echo "MySQL está listo"
python manage.py collectstatic --noinput || true
python manage.py migrate --noinput
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
python manage.py runserver 0.0.0.0:8000

