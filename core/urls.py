from django.contrib import admin
from django.urls import path, include
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView, TokenVerifyView
from accounts.urls import urlpatterns as accounts_urls
from .api import urlpatterns as api_urls
from .api_custom import ProductsView, OrdersView, OrderConfirmView
from .api_custom import KPIsView
from healthz import healthz

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def index(request):
    return Response({'api_root':'/api/','schema':'/api/schema/','docs':'/api/docs/','admin':'/admin/'})

urlpatterns = [
    path('admin/', admin.site.urls),
    path('healthz', healthz, name='healthz'),
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema')),
    path('api/auth/jwt/create', TokenObtainPairView.as_view(), name='jwt_create'),
    path('api/auth/jwt/refresh', TokenRefreshView.as_view(), name='jwt_refresh'),
    path('api/auth/jwt/verify', TokenVerifyView.as_view(), name='jwt_verify'),
    path('api/', include('rest_framework.urls')),
    path('api/', include(api_urls)),
    path('api/auth/', include(accounts_urls)),
    path('ui/', include('ui.urls')),
    # Frontend-expected endpoints
    path('api/catalog/products/', ProductsView.as_view(), name='catalog-products'),
    path('api/orders/', OrdersView.as_view(), name='orders'),
    path('api/orders/<int:pk>/confirm/', OrderConfirmView.as_view(), name='order-confirm'),
    path('api/metrics/kpis/', KPIsView.as_view(), name='kpis'),
    path('', index, name='index'),
]
