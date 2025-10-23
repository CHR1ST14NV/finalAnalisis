# finalAnalisis – Stack Docker + Django + MySQL

Proyecto listo para levantar con un solo comando usando MySQL dentro del mismo `docker compose`. La app espera a la base, migra y arranca automáticamente.

## Levantar servicios

```
docker compose up -d --build
```

- API directa (Django): http://localhost:8001/
- API vía Nginx: http://localhost:3000/api/
- Frontend (Nginx → Vite static): http://localhost:3000/
- UI CRUD (server-side): http://localhost:3000/ui/
- MySQL (host): 127.0.0.1:3309 (usuario: `root`, pass: `admin`)
- Adminer: http://localhost:8080/ (Servidor: `mysql`, Usuario: `root`, Pass: `admin`, DB: `final_analisis`)

El servicio `web` espera a MySQL, crea la base si no existe, GENERA migraciones que falten (makemigrations), migra con `--fake-initial` para respetar tablas ya existentes en tu MySQL, carga estáticos y arranca en `0.0.0.0:8000`. El healthcheck expone `GET /healthz` dentro del contenedor y es usado por Compose.

## Variables de entorno (.env)

Se incluye `.env.example` con valores por defecto. Copia como `.env` si lo necesitas.

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

# Crear superusuario automáticamente (opcional)
DJANGO_SUPERUSER_EMAIL=admin@local
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=admin12345

ENV=dev
```

La configuración de Django detecta si `MYSQL_HOST` es `127.0.0.1` o `localhost` y en ese caso usa automáticamente `MYSQL_HOST_DOCKER=mysql` al correr dentro del contenedor.

Notas sobre migraciones y tu base existente:

- Si tu volumen de MySQL ya contiene el esquema y datos (como tu `sql.sql`), el paso `migrate --fake-initial` marcará los migrations iniciales como aplicados sin tocar las tablas.
- Si faltaran archivos de migración en el repo para alguna app, el entrypoint ejecuta `makemigrations` antes de migrar, generándolos automáticamente y manteniéndolos en el volumen del proyecto.
- Esto te permite clonar y levantar con un solo comando sin “truenes”, conservando la base ya poblada en Docker.

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

En Linux agrega al servicio `web` de `docker-compose.yml`:

```
extra_hosts:
  - "host.docker.internal:host-gateway"
```

## Notas

- No se requiere Postgres. El backend es `django.db.backends.mysql` y `requirements.txt` incluye `mysqlclient`.
- Se añadió healthcheck al servicio web y `curl` en la imagen para mayor confiabilidad en arranque.
- Hay archivos de otra plataforma (`chan_platform`, k8s, etc.) que no se usan en este stack con MySQL; puedes ignorarlos o removerlos si deseas simplificar aún más.
