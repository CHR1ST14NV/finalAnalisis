#!/usr/bin/env bash
set -euo pipefail
host=${1:-db}
user=${2:-chan}
until PGPASSWORD=${DB_PASSWORD:-chan} psql -h "$host" -U "$user" -c '\q' >/dev/null 2>&1; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
echo "Postgres is up"

