# chan_platform

Plataforma modular (SOA) para canal: catálogo, inventario one‑pallet, pedidos, fulfillment, marketing y liquidaciones. Stack: Python 3.12, Django 5 (ASGI), DRF, PostgreSQL, Redis, Celery, MinIO, OpenTelemetry, Prometheus, Grafana, Nginx y frontend React + TypeScript + Vite + Tailwind.

## Quickstart

1) Copiar variables:

```
cp .env.example .env
```

2) Levantar stack (producción local con Docker):

```
docker compose up -d --build
```

3) Migraciones y seeds (se ejecutan al arrancar; opcional repetir):

```
docker compose exec web python manage.py migrate
docker compose exec web python manage.py seed_demo
```

4) Acceso

- App detrás de Nginx: http://localhost:3000/
- OpenAPI JSON: http://localhost:3000/api/schema/
- Swagger UI: http://localhost:3000/api/docs/
- Prometheus metrics: http://localhost:3000/metrics
- Grafana: http://localhost:3000/grafana (admin/admin)

5) Credenciales demo

- Superuser: `admin` / `admin123!` (cambiar en `.env` o tras login)

Frontend
- UI moderna (tema oscuro), navegación superior fija y páginas: Inicio, Catálogo/Productos, Pedidos, Inventario, KPI, Login/Perfil.
- Tablas con paginación/búsqueda server‑side, formularios validados y KPIs con Recharts.
- Cliente API tipado (Zod) con sesión JWT (refresh transparente) y rutas protegidas.

## Make (DX)

```
make up        # docker compose up -d
make down      # docker compose down -v
make logs      # tail logs
make migrate   # run migrations
make su        # create superuser
make seed      # demo data
make test      # pytest
make lint      # ruff + mypy
make format    # black
make openapi   # generate docs/openapi.json
```

## Criterios mínimos

- Pedido B2B crea reserva atómica (Redis lock) y evento OrderCreated.
- Confirmación aloca stock con FEFO; si falla envío, compensa liberando.
- Nginx sirve en :3000 → web:8000 estable.
- OpenAPI documentada y contract tests base.
- Observabilidad: OTel + Prometheus + Grafana dashboard de KPIs.

