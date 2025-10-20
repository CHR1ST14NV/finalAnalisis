from django.db import models
from common.models import AbstractAuditMixin
from catalog.models import SKU


class PriceList(AbstractAuditMixin):
    name = models.CharField(max_length=120, unique=True)
    currency = models.CharField(max_length=3, default='USD')
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name


class PriceItem(AbstractAuditMixin):
    pricelist = models.ForeignKey(PriceList, on_delete=models.CASCADE, related_name='items')
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    valid_from = models.DateTimeField()
    valid_to = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = (('pricelist', 'sku', 'valid_from'),)

