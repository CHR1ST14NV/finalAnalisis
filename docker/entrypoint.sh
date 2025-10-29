#!/usr/bin/env bash
set -euo pipefail

DB_HOST=${DB_HOST:-mysql}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER:-root}
DB_PASSWORD=${DB_PASSWORD:-admin}
export MYSQL_PWD="$DB_PASSWORD"

# Wait for TCP socket first (more robust if mysqladmin fails)
until nc -z "$DB_HOST" "$DB_PORT" >/dev/null 2>&1; do
  echo "Waiting for MySQL (TCP ${DB_HOST}:${DB_PORT})..."
  sleep 2
done

# Verify credentials by running a simple query
ok=0
for i in {1..40}; do
  if mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -e "SELECT 1" >/dev/null 2>&1; then
    ok=1; break
  fi
  echo "Waiting for MySQL (auth)..."
  sleep 2
done
if [ "$ok" != "1" ]; then
  echo "MySQL did not respond to auth after several attempts" >&2
  exit 1
fi
echo "MySQL is ready"

# Create database if not exists (useful if volume already existed)
DB_NAME_CREATE=${MYSQL_DB:-${DB_NAME:-final_analisis}}
mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME_CREATE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" || true

# Grupo #6: aplicamos migraciones por defecto para robustez en clones limpios
# (si la base ya está pre-cargada, se usan flags para evitar conflictos)
if [ "${MIGRATE_ON_START:-1}" = "1" ]; then
  # Apply migrations against the existing DB
  # --fake-initial will mark initial migrations as applied if tables already exist
  if [ "${AUTO_MAKEMIGRATIONS:-0}" = "1" ]; then
    python manage.py makemigrations --noinput || true
  fi

  set +e
  python manage.py migrate --noinput --fake-initial
  migrate_rc=$?
  set -e

  if [ "$migrate_rc" != "0" ]; then
    echo "Initial migrate failed, attempting index compatibility fix for pre-seeded DB..."
    DB_NAME_EXEC=${MYSQL_DB:-${DB_NAME:-final_analisis}}
    # Try orders index variants
    mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" "$DB_NAME_EXEC" -e \
      "ALTER TABLE \`orders_retailerorder\` RENAME INDEX \`orders_reta_status__e19a1e_idx\` TO \`orders_reta_status_8db34d_idx\`;" || true
    mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" "$DB_NAME_EXEC" -e \
      "ALTER TABLE \`orders_retailerorder\` RENAME INDEX \`ix_order_status_created\` TO \`orders_reta_status_8db34d_idx\`;" || true
    mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" "$DB_NAME_EXEC" -e \
      "ALTER TABLE \`orders_retailerorder\` ADD INDEX \`orders_reta_status_8db34d_idx\` (\`status\`, \`created_at\`);" || true

    # Try warehouses index variants
    mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" "$DB_NAME_EXEC" -e \
      "ALTER TABLE \`warehouses_inventorybatch\` RENAME INDEX \`warehouses__warehouse_6a59b1_idx\` TO \`warehouses__warehou_d82d4c_idx\`;" || true
    mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" "$DB_NAME_EXEC" -e \
      "ALTER TABLE \`warehouses_inventorybatch\` RENAME INDEX \`ix_batch_fefo\` TO \`warehouses__warehou_d82d4c_idx\`;" || true
    mysql --protocol=tcp -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" "$DB_NAME_EXEC" -e \
      "ALTER TABLE \`warehouses_inventorybatch\` ADD INDEX \`warehouses__warehou_d82d4c_idx\` (\`warehouse_id\`, \`sku_id\`, \`expires_at\`);" || true

    # Mark fragile rename-only migrations as applied if present
    python manage.py migrate orders 0003 --fake --noinput || true
    python manage.py migrate orders 0004 --fake --noinput || true
    python manage.py migrate warehouses 0002 --fake --noinput || true

    # Re-run migrate (non-fatal if still failing; DB is pre-seeded)
    set +e
    python manage.py migrate --noinput --fake-initial
    set -e
  fi
else
  echo "Skipping migrations (MIGRATE_ON_START=0). Assuming database is pre-seeded."
fi
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
    print('Created superuser')
else:
    print('Superuser already exists')
PY
fi

if [ "${ENV:-dev}" = "dev" ]; then
  python manage.py seed_demo || true
fi

exec python manage.py runserver 0.0.0.0:8000
