from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet, SKUViewSet, CategoryViewSet

router = DefaultRouter()
router.register(r"products", ProductViewSet, basename="product")
router.register(r"skus", SKUViewSet, basename="sku")
router.register(r"categories", CategoryViewSet, basename="category")

urlpatterns = [
    path("", include(router.urls)),
]
