# finalAnalisis - Stack Docker + Django + MySQL (Grupo #6)

Este proyecto full-stack (backend Django + frontend Vite/React + Nginx) esta listo para levantarse con un solo comando. La base de datos MySQL se inicializa con todo el esquema y datos de ejemplo ya incluidos.

Importante: toda la atribucion y notas de Grupo #6 estan solo en comentarios de codigo/docstrings; no se muestra nada al usuario final.

## Levantar servicios

```
docker compose up -d --build
```

- API directa (Django): http://localhost:8001/
- API via Nginx: http://localhost:3000/api/
- Frontend (estetico con Vite servido por Nginx): http://localhost:3000/
- UI CRUD (server-side): http://localhost:3000/ui/
- MySQL (host): 127.0.0.1:3309 (usuario: `root`, pass: `admin`)
- Adminer: http://localhost:8080/ (Servidor: `mysql`, Usuario: `root`, Pass: `admin`, DB: `final_analisis`)

El servicio `web` espera la base, crea la BD si no existe, aplica migraciones de forma segura para respetar esquemas ya poblados, recolecta est�ticos y arranca `runserver` en `0.0.0.0:8000`. Healthcheck: `GET /healthz`.

## Variables de entorno (.env)

Hay un `.env.example` con valores por defecto. Puedes copiarlo a `.env` si lo necesitas.

Claves relevantes:

```
DJANGO_DEBUG=True
DJANGO_SECRET_KEY=change-me-please
DJANGO_ALLOWED_HOSTS=*
TIME_ZONE=America/Guatemala
LANGUAGE_CODE=es

# Acceso desde tu host (puerto publicado por compose)
MYSQL_HOST=127.0.0.1
MYSQL_PORT=3309
MYSQL_DB=final_analisis
MYSQL_USER=root
MYSQL_PASSWORD=admin

# Acceso dentro de la red de Docker (lo usa el contenedor web)
MYSQL_HOST_DOCKER=mysql
MYSQL_PORT_DOCKER=3306

# Crear superusuario autom�ticamente (opcional)
DJANGO_SUPERUSER_EMAIL=admin@local
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=admin12345

ENV=dev
```

La configuracion de Django detecta si `MYSQL_HOST` es `127.0.0.1` o `localhost` y en ese caso usa autom�ticamente `MYSQL_HOST_DOCKER=mysql` cuando corre dentro del contenedor.

### Migraciones y base pre-cargada

- Si tu volumen de MySQL ya contiene el esquema y datos (los del repo), el entrypoint usa estrategias conservadoras (`--fake-initial` y ajustes de indices) para no romper nada.
- Si necesitas crear tablas porque el SQL no corri� por alguna raz�n, el servicio `web` aplica migraciones al arrancar (configurado por defecto para robustez).

## Probar la base de datos (desde tu host)

```
mysql -h 127.0.0.1 -P 3309 -uroot -padmin -e "SHOW DATABASES;"
```

## Usar MySQL local en vez del contenedor (opcional)

En `.env` coloca:

```
MYSQL_HOST=host.docker.internal
MYSQL_PORT=3306
```

En Linux agrega al servicio `web` en `docker-compose.yml`:

```
extra_hosts:
  - "host.docker.internal:host-gateway"
```

## Notas

- No se requiere Postgres. El backend usa `django.db.backends.mysql` y `requirements.txt` incluye `mysqlclient`.
- El proyecto incluye healthcheck y utilidades para evitar condiciones de carrera al arrancar.
- Se eliminaron archivos no usados (k8s, OTel, Prometheus, plantillas antiguas) para simplificar el stack.
