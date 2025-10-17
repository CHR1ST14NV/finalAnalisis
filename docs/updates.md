# Updates Implemented

- Frontend JWT session now persists access/refresh tokens in `sessionStorage`, with transparent refresh and `logout`.
- Protected routes for Orders, Inventory and KPI via a `RequireAuth` component.
- Frontend sends `Idempotency-Key` headers for write operations (create/confirm order).
- RBAC enforced for order confirmation (admin / operador_central / operator).
- Celery worker and beat instrumented with OpenTelemetry (`opentelemetry-instrument`).
- Docker Compose env updated with sane defaults for local CORS, Prometheus URL and webhook secret.

This augments the existing architecture without breaking `docker compose up -d --build`.

