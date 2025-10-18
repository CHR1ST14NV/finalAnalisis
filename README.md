# finalAnalisis – MySQL + Docker

Este proyecto está configurado para usar MySQL con Docker, con persistencia real y sin Postgres.

## Levantar servicios

```
docker compose up -d --build
```

- API: http://localhost:8000
- MySQL: 127.0.0.1:3309 (root/admin)
- Adminer: http://localhost:8080 (Servidor: `mysql`, Usuario: `root`, Contraseña: `admin`, DB: `app_db`)

Al iniciar, el contenedor `web` espera a MySQL, corre migraciones y levanta `runserver` en 0.0.0.0:8000. Si defines las variables de superusuario en `.env`, se crea automáticamente.

## Variables de entorno (.env)

```
DJANGO_DEBUG=True
DJANGO_SECRET_KEY=change-me-please
DJANGO_ALLOWED_HOSTS=*
TIME_ZONE=America/Guatemala

DB_ENGINE=mysql
DB_NAME=app_db
DB_USER=root
DB_PASSWORD=admin
DB_HOST=mysql
DB_PORT=3306

DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_PASSWORD=admin123
```

## Probar la base de datos

- CLI MySQL desde host:

```
mysql -h 127.0.0.1 -P 3309 -uroot -padmin -e "SHOW DATABASES;"
```

- IP interna del contenedor MySQL:

```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql
```

## Usar MySQL local (XAMPP/WAMP)

Si prefieres usar tu MySQL local en `localhost:3306 (root/admin)`, ajusta `.env`:

```
DB_HOST=host.docker.internal
DB_PORT=3306
```

(En Linux agrega al servicio `web` en docker-compose: `extra_hosts: - "host.docker.internal:host-gateway"`).

## API de ejemplo

- JWT: `POST /api/token/` (username/password) y `POST /api/token/refresh/`
- Índice protegido: `GET /` (requiere Authorization: Bearer)
- CRUD protegido por propietario: `GET/POST /api/notes/`, `GET/PUT/PATCH/DELETE /api/notes/{id}/`
- OpenAPI: `GET /api/schema/` y Swagger UI: `GET /api/docs/`

## Sin Postgres

- Compose no incluye servicios de Postgres.
- `requirements.txt` sin `psycopg2`.
- Configuración Django con backend `django.db.backends.mysql`.
