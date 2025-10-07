import uuid
from django.db import models
from django.utils import timezone
from apps.catalog.models import SKU


def uuid7():
    return uuid.uuid4()


class Warehouse(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=120)
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)

    def __str__(self):
        return self.code


class StockBatch(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    warehouse = models.ForeignKey(Warehouse, on_delete=models.PROTECT)
    lot = models.CharField(max_length=64)
    qty = models.IntegerField()
    available_qty = models.IntegerField()
    received_at = models.DateTimeField(default=timezone.now)
    expires_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = ("sku", "warehouse", "lot")


class StockLedger(models.Model):
    INBOUND = "INBOUND"
    RESERVE = "RESERVE"
    RELEASE = "RELEASE"
    ALLOCATE = "ALLOCATE"
    SHIP = "SHIP"
    ADJUST = "ADJUST"
    EVENT_CHOICES = [
        (INBOUND, INBOUND),
        (RESERVE, RESERVE),
        (RELEASE, RELEASE),
        (ALLOCATE, ALLOCATE),
        (SHIP, SHIP),
        (ADJUST, ADJUST),
    ]

    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    warehouse = models.ForeignKey(Warehouse, on_delete=models.PROTECT)
    event = models.CharField(max_length=16, choices=EVENT_CHOICES)
    delta = models.IntegerField()
    batch = models.ForeignKey(StockBatch, null=True, blank=True, on_delete=models.PROTECT)
    ref = models.CharField(max_length=64, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        indexes = [models.Index(fields=["sku", "warehouse", "created_at"]) ]


class Reservation(models.Model):
    PENDING = "PENDING"
    CONFIRMED = "CONFIRMED"
    CANCELLED = "CANCELLED"
    EXPIRED = "EXPIRED"
    STATUS_CHOICES = [(PENDING, PENDING), (CONFIRMED, CONFIRMED), (CANCELLED, CANCELLED), (EXPIRED, EXPIRED)]

    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    warehouse = models.ForeignKey(Warehouse, on_delete=models.PROTECT)
    qty = models.IntegerField()
    status = models.CharField(max_length=12, choices=STATUS_CHOICES, default=PENDING)
    ttl_expires_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    order_ref = models.CharField(max_length=64, blank=True)


