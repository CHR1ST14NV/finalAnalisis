from django.contrib import admin
from django.urls import path, include
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from rest_framework.routers import DefaultRouter
from example.views import NoteViewSet

router = DefaultRouter()
router.register(r'notes', NoteViewSet, basename='note')

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def index(request):
    return Response({'api_root':'/api/','schema':'/api/schema/','docs':'/api/docs/','admin':'/admin/'})

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/docs/', SpectacularSwaggerView.as_view(url_name='schema')),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/', include('rest_framework.urls')),
    path('api/', include(router.urls)),
    path('', index, name='index'),
]

