"""Cumplimiento y envíos (Grupo #6)."""
from django.db import models
from common.models import AbstractAuditMixin
from orders.models import RetailerOrder, OrderItem


class Carrier(AbstractAuditMixin):
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=120)

    def __str__(self):
        return self.code


class Shipment(AbstractAuditMixin):
    CREATED = 'CREATED'
    DISPATCHED = 'DISPATCHED'
    DELIVERED = 'DELIVERED'
    CANCELLED = 'CANCELLED'
    STATUS_CHOICES = [(CREATED, CREATED), (DISPATCHED, DISPATCHED), (DELIVERED, DELIVERED), (CANCELLED, CANCELLED)]

    code = models.CharField(max_length=32, unique=True)
    order = models.ForeignKey(RetailerOrder, on_delete=models.CASCADE, related_name='shipments')
    carrier = models.ForeignKey(Carrier, on_delete=models.PROTECT, null=True, blank=True)
    tracking = models.CharField(max_length=64, unique=True)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default=CREATED)


class ShipmentItem(AbstractAuditMixin):
    shipment = models.ForeignKey(Shipment, on_delete=models.CASCADE, related_name='items')
    order_item = models.ForeignKey(OrderItem, on_delete=models.PROTECT)
    qty = models.IntegerField()
