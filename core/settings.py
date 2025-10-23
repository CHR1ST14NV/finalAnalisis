import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY','dev-secret')
DEBUG = os.getenv('DJANGO_DEBUG','False') == 'True'
ALLOWED_HOSTS = os.getenv('DJANGO_ALLOWED_HOSTS','*').split(',')
TIME_ZONE = os.getenv('TIME_ZONE','America/Guatemala')
LANGUAGE_CODE = os.getenv('LANGUAGE_CODE','es')
USE_TZ = True

INSTALLED_APPS = [
    'django.contrib.admin','django.contrib.auth','django.contrib.contenttypes',
    'django.contrib.sessions','django.contrib.messages','django.contrib.staticfiles',
    'rest_framework','drf_spectacular','corsheaders','django_filters',
    'common','accounts','partners','catalog','pricing','promo','warehouses','orders','fulfillment','returns','finance',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware','django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware','django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware','django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

CORS_ALLOW_ALL_ORIGINS = True

REST_FRAMEWORK = {
    'DEFAULT_SCHEMA_CLASS':'drf_spectacular.openapi.AutoSchema',
    'DEFAULT_AUTHENTICATION_CLASSES':('rest_framework_simplejwt.authentication.JWTAuthentication',),
    'DEFAULT_PERMISSION_CLASSES':('rest_framework.permissions.IsAuthenticated',),
    'DEFAULT_FILTER_BACKENDS': (
        'django_filters.rest_framework.DjangoFilterBackend',
        'rest_framework.filters.SearchFilter',
        'rest_framework.filters.OrderingFilter',
    ),
}

SPECTACULAR_SETTINGS = {'TITLE':'finalAnalisis API','DESCRIPTION':'API con MySQL y JWT','VERSION':'1.0.0'}

ROOT_URLCONF = 'core.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    }
]

_host_env = os.getenv('MYSQL_HOST', os.getenv('DB_HOST','mysql'))
_port_env = os.getenv('MYSQL_PORT', os.getenv('DB_PORT','3306'))
if _host_env in ('127.0.0.1','localhost'):
    # Dentro del contenedor usamos la red de Docker
    _host = os.getenv('MYSQL_HOST_DOCKER','mysql')
    _port = os.getenv('MYSQL_PORT_DOCKER','3306')
else:
    _host = _host_env
    _port = _port_env

DATABASES = {
    'default': {
        'ENGINE':'django.db.backends.mysql',
        'NAME': os.getenv('MYSQL_DB', os.getenv('DB_NAME','final_analisis')),
        'USER': os.getenv('MYSQL_USER', os.getenv('DB_USER','root')),
        'PASSWORD': os.getenv('MYSQL_PASSWORD', os.getenv('DB_PASSWORD','admin')),
        'HOST': _host,
        'PORT': _port,
        'OPTIONS': {'charset':'utf8mb4','use_unicode':True,'init_command':"SET sql_mode='STRICT_ALL_TABLES'"},
    }
}

STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
AUTH_USER_MODEL = 'accounts.User'
