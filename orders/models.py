"""Órdenes de retailers y líneas (Grupo #6)."""
from django.db import models
from common.models import AbstractAuditMixin
from partners.models import Retailer
from warehouses.models import Warehouse, InventoryBatch
from catalog.models import SKU


class RetailerOrder(AbstractAuditMixin):
    DRAFT = 'DRAFT'
    PLACED = 'PLACED'
    ALLOCATED = 'ALLOCATED'
    PICKED = 'PICKED'
    SHIPPED = 'SHIPPED'
    DELIVERED = 'DELIVERED'
    CANCELLED = 'CANCELLED'
    STATUS_CHOICES = [
        (DRAFT, DRAFT), (PLACED, PLACED), (ALLOCATED, ALLOCATED),
        (PICKED, PICKED), (SHIPPED, SHIPPED), (DELIVERED, DELIVERED), (CANCELLED, CANCELLED)
    ]

    code = models.CharField(max_length=32, unique=True)
    retailer = models.ForeignKey(Retailer, on_delete=models.PROTECT)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default=DRAFT)
    warehouse = models.ForeignKey(Warehouse, on_delete=models.PROTECT, null=True, blank=True)

    class Meta:
        indexes = [models.Index(fields=['status', 'created_at'])]

    def __str__(self):
        return self.code


class OrderItem(AbstractAuditMixin):
    order = models.ForeignKey(RetailerOrder, on_delete=models.CASCADE, related_name='items')
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    qty = models.IntegerField()
    unit_price = models.DecimalField(max_digits=12, decimal_places=2)


class Reservation(AbstractAuditMixin):
    order_item = models.ForeignKey(OrderItem, on_delete=models.CASCADE, related_name='reservations')
    batch = models.ForeignKey(InventoryBatch, on_delete=models.PROTECT)
    qty = models.IntegerField()


class Allocation(AbstractAuditMixin):
    order_item = models.ForeignKey(OrderItem, on_delete=models.CASCADE, related_name='allocations')
    batch = models.ForeignKey(InventoryBatch, on_delete=models.PROTECT)
    qty = models.IntegerField()
