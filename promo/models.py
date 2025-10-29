"""Promociones y descuentos (Grupo #6)."""
from django.db import models
from common.models import AbstractAuditMixin
from catalog.models import SKU


class Promotion(AbstractAuditMixin):
    name = models.CharField(max_length=120)
    percent_off = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    starts_at = models.DateTimeField()
    ends_at = models.DateTimeField()
    is_active = models.BooleanField(default=True)
    skus = models.ManyToManyField(SKU, blank=True, related_name='promotions')

    def __str__(self):
        return self.name
