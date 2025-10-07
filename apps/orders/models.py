import uuid
from django.db import models
from django.utils import timezone
from apps.catalog.models import SKU
from apps.users.models import uuid7
from apps.inventory.models import Warehouse, Reservation


class Order(models.Model):
    DRAFT = "DRAFT"
    PLACED = "PLACED"
    CONFIRMED = "CONFIRMED"
    ALLOCATED = "ALLOCATED"
    PICKED = "PICKED"
    SHIPPED = "SHIPPED"
    DELIVERED = "DELIVERED"
    SETTLED = "SETTLED"
    CLOSED = "CLOSED"
    STATUS_CHOICES = [
        (DRAFT, DRAFT),
        (PLACED, PLACED),
        (CONFIRMED, CONFIRMED),
        (ALLOCATED, ALLOCATED),
        (PICKED, PICKED),
        (SHIPPED, SHIPPED),
        (DELIVERED, DELIVERED),
        (SETTLED, SETTLED),
        (CLOSED, CLOSED),
    ]

    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default=PLACED)
    customer_ref = models.CharField(max_length=64)
    channel = models.CharField(max_length=32, default="B2B")
    warehouse = models.ForeignKey(Warehouse, on_delete=models.PROTECT)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        indexes = [models.Index(fields=["status", "created_at"]) ]


class OrderItem(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="items")
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    qty = models.IntegerField()
    unit_price = models.DecimalField(max_digits=12, decimal_places=2)


class Payment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="payments")
    provider = models.CharField(max_length=32, default="mock")
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    status = models.CharField(max_length=16, default="AUTHORIZED")
    created_at = models.DateTimeField(auto_now_add=True)


class Return(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="returns")
    reason = models.CharField(max_length=120)
    created_at = models.DateTimeField(auto_now_add=True)

