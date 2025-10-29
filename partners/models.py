"""Modelos de socios comerciales (Grupo #6)."""
from django.db import models
from common.models import AbstractAuditMixin


class Distributor(AbstractAuditMixin):
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=120)

    def __str__(self):
        return self.code


class Retailer(AbstractAuditMixin):
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=120)
    distributor = models.ForeignKey(Distributor, on_delete=models.PROTECT, related_name='retailers')

    def __str__(self):
        return self.code
