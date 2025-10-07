from django.db.models import Q
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticatedOrReadOnly
from .models import Product, SKU
from .serializers import ProductSerializer, SKUSerializer


class ProductViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Product.objects.select_related("category").all()
    serializer_class = ProductSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get_queryset(self):
        qs = super().get_queryset()
        q = self.request.query_params.get("q")
        category = self.request.query_params.get("category")
        if q:
            qs = qs.filter(Q(name__icontains=q) | Q(description__icontains=q))
        if category:
            qs = qs.filter(category_id=category)
        return qs


class SKUViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = SKU.objects.select_related("product").all()
    serializer_class = SKUSerializer
    permission_classes = [IsAuthenticatedOrReadOnly]

