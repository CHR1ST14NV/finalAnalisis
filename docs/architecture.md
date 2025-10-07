# Arquitectura

Plataforma SOA modular en Django 5, con apps independientes por bounded context. Inventario one‑pallet con libro mayor event‑sourced, reservas atómicas (Redis lock), y asignación FEFO. Workflows asíncronos con Celery; observabilidad con OpenTelemetry, Prometheus y Grafana.

## Dominio
- Catalog: productos, SKUs, listas de precio, promociones.
- Inventory: warehouses, batches, ledger, reservations.
- Orders: pedidos, items, pagos, devoluciones; estados y saga de fulfillment.
- Fulfillment: proveedores carrier‑agnostic (adapter), shipments y webhooks con HMAC.
- Settlements: políticas, rebates, runs/lines periódicas.
- Marketing: segmentos, campañas, cupones.
- Integrations: MinIO, ERP/WMS (stubs).
- Audit: trazabilidad request/response con TTL.

## Seguridad
- JWT (SimpleJWT), RBAC por roles, throttling DRF con Redis, CORS, CSRF.

## Observabilidad
- OTel (OTLP → collector), Prometheus (django-prometheus), Grafana dashboards.

