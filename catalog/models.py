"""Catálogo de productos (Grupo #6)."""
from django.db import models
from common.models import AbstractAuditMixin


class Brand(AbstractAuditMixin):
    name = models.CharField(max_length=120, unique=True)

    def __str__(self):
        return self.name


class Category(AbstractAuditMixin):
    name = models.CharField(max_length=120, unique=True)
    parent = models.ForeignKey('self', null=True, blank=True, on_delete=models.PROTECT)

    def __str__(self):
        return self.name


class Product(AbstractAuditMixin):
    name = models.CharField(max_length=200)
    brand = models.ForeignKey(Brand, on_delete=models.PROTECT, null=True, blank=True)
    category = models.ForeignKey(Category, on_delete=models.PROTECT, null=True, blank=True)

    def __str__(self):
        return self.name


class SKU(AbstractAuditMixin):
    product = models.ForeignKey(Product, on_delete=models.PROTECT, related_name='skus')
    code = models.CharField(max_length=64, unique=True)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.code
