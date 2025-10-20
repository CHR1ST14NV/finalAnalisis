from django.db import models
from common.models import AbstractAuditMixin
from catalog.models import SKU


class Warehouse(AbstractAuditMixin):
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=120)

    def __str__(self):
        return self.code


class InventoryBatch(AbstractAuditMixin):
    warehouse = models.ForeignKey(Warehouse, on_delete=models.PROTECT, related_name='batches')
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    lot = models.CharField(max_length=64)
    expires_at = models.DateField(null=True, blank=True)
    qty_on_hand = models.IntegerField()
    qty_reserved = models.IntegerField(default=0)

    class Meta:
        unique_together = (('warehouse', 'sku', 'lot'),)
        indexes = [
            models.Index(fields=['warehouse', 'sku', 'expires_at']),
        ]


class ReplenishmentRule(AbstractAuditMixin):
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    warehouse = models.ForeignKey(Warehouse, on_delete=models.PROTECT)
    min_qty = models.IntegerField(default=0)
    target_qty = models.IntegerField(default=0)

    class Meta:
        unique_together = (('sku', 'warehouse'),)

