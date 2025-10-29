"""Devoluciones y recompras (Grupo #6)."""
from django.db import models
from common.models import AbstractAuditMixin
from partners.models import Retailer
from warehouses.models import InventoryBatch


class Buyback(AbstractAuditMixin):
    retailer = models.ForeignKey(Retailer, on_delete=models.PROTECT, related_name='buybacks')


class BuybackItem(AbstractAuditMixin):
    buyback = models.ForeignKey(Buyback, on_delete=models.CASCADE, related_name='items')
    batch = models.ForeignKey(InventoryBatch, on_delete=models.PROTECT)
    qty = models.IntegerField()
