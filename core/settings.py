import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY','dev-secret')
DEBUG = os.getenv('DJANGO_DEBUG','False') == 'True'
ALLOWED_HOSTS = os.getenv('DJANGO_ALLOWED_HOSTS','*').split(',')
TIME_ZONE = os.getenv('TIME_ZONE','America/Guatemala')
USE_TZ = True

INSTALLED_APPS = [
    'django.contrib.admin','django.contrib.auth','django.contrib.contenttypes',
    'django.contrib.sessions','django.contrib.messages','django.contrib.staticfiles',
    'rest_framework','drf_spectacular','corsheaders','example',
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
}

SPECTACULAR_SETTINGS = {'TITLE':'finalAnalisis API','DESCRIPTION':'API con MySQL y JWT','VERSION':'1.0.0'}

ROOT_URLCONF = 'core.urls'

DATABASES = {
    'default': {
        'ENGINE':'django.db.backends.mysql',
        'NAME': os.getenv('DB_NAME','app_db'),
        'USER': os.getenv('DB_USER','root'),
        'PASSWORD': os.getenv('DB_PASSWORD','admin'),
        'HOST': os.getenv('DB_HOST','mysql'),
        'PORT': os.getenv('DB_PORT','3306'),
        'OPTIONS': {'charset':'utf8mb4','use_unicode':True,'init_command':"SET sql_mode='STRICT_ALL_TABLES'"},
    }
}

STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'
