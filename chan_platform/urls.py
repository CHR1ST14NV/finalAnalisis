from django.contrib import admin
from django.urls import include, path
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from django.views.generic.base import RedirectView
from healthz import healthz

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="schema"), name="swagger-ui"),
    path("api/v1/", include("apps.api_router")),
    path("", include("django_prometheus.urls")),
    path("", RedirectView.as_view(url="/api/docs/", permanent=False)),
    path("healthz", healthz),
]
