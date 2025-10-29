from rest_framework import routers, viewsets, serializers
from django.urls import path, include
from django.apps import apps
from rest_framework.permissions import IsAuthenticated, SAFE_METHODS
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from django.db import models


def build_modelviewset(model):
    """Builds a DRF ModelViewSet dynamically for the given model.

    Uses a dynamically generated serializer and closures that capture the
    model via default arguments to avoid scope issues at import time.
    """

    Meta = type('Meta', (), {'model': model, 'fields': '__all__'})
    serializer_cls = type(f'{model.__name__}Serializer', (serializers.ModelSerializer,), {'Meta': Meta})

    def _get_permissions(self, _model=model):
        if self.request.method in SAFE_METHODS:
            return [p() for p in self.permission_classes]
        u = self.request.user
        if hasattr(u, 'has_role') and (u.has_role('ADMIN', 'HQ_OPERATOR') or getattr(u, 'is_superuser', False)):
            return [p() for p in self.permission_classes]
        if _model._meta.app_label in ('warehouses', 'fulfillment') and hasattr(u, 'has_role') and u.has_role('WAREHOUSE_OP'):
            return [p() for p in self.permission_classes]
        if _model._meta.app_label == 'orders' and hasattr(u, 'has_role') and u.has_role('RETAILER'):
            return [p() for p in self.permission_classes]
        if _model._meta.label_lower == 'partners.retailer' and hasattr(u, 'has_role') and u.has_role('DISTRIBUTOR'):
            return [p() for p in self.permission_classes]
        return []

    def _get_queryset(self, _model=model):
        qs = _model.objects.all()
        u = self.request.user
        if not getattr(u, 'is_superuser', False) and hasattr(u, 'has_role'):
            if _model._meta.label_lower == 'partners.retailer' and u.has_role('DISTRIBUTOR') and getattr(u, 'distributor_id', None):
                return qs.filter(distributor_id=u.distributor_id)
            if _model._meta.label_lower == 'orders.retailerorder':
                if u.has_role('RETAILER') and getattr(u, 'retailer_id', None):
                    return qs.filter(retailer_id=u.retailer_id)
                if u.has_role('DISTRIBUTOR') and getattr(u, 'distributor_id', None):
                    return qs.filter(retailer__distributor_id=u.distributor_id)
        # performance: auto select_related/prefetch for relations
        try:
            fk_fields = [f.name for f in _model._meta.get_fields() if getattr(f, 'many_to_one', False) and f.concrete]
            m2m_fields = [f.name for f in _model._meta.get_fields() if getattr(f, 'many_to_many', False) and f.concrete]
            if fk_fields:
                qs = qs.select_related(*fk_fields)
            if m2m_fields:
                qs = qs.prefetch_related(*m2m_fields)
        except Exception:
            pass
        return qs

    attrs = {
        'queryset': model.objects.all(),
        'serializer_class': serializer_cls,
        'permission_classes': [IsAuthenticated],
        'filter_backends': [DjangoFilterBackend, SearchFilter, OrderingFilter],
        'filterset_fields': [
            f.name for f in model._meta.fields if isinstance(
                f, (models.CharField, models.IntegerField, models.ForeignKey, models.DateField, models.DateTimeField)
            )
        ],
        'search_fields': [f.name for f in model._meta.fields if isinstance(f, models.CharField)],
        'ordering_fields': [f.name for f in model._meta.fields],
        'get_permissions': _get_permissions,
        'get_queryset': _get_queryset,
    }

    viewset_cls = type(f'{model.__name__}ViewSet', (viewsets.ModelViewSet,), attrs)
    return viewset_cls


def build_router():
    r = routers.DefaultRouter()
    include_apps = ['accounts', 'partners', 'catalog', 'pricing', 'promo', 'warehouses', 'orders', 'fulfillment', 'returns', 'finance']
    for app_label in include_apps:
        for model in apps.get_app_config(app_label).get_models():
            # no exponer User vía router genérico
            if model._meta.label_lower == 'accounts.user':
                continue
            vs = build_modelviewset(model)
            name = f"{app_label}-{model.__name__.lower()}"
            r.register(name, vs, basename=name)
    return r


router = build_router()
urlpatterns = [path('', include(router.urls))]
"""Enrutador dinámico de API (Grupo #6).

Expone ModelViewSets generados para las apps de dominio, con
permisos y filtros razonables para un uso demo/controlado.
"""
