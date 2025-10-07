import uuid
from django.db import models
from apps.orders.models import Order
from apps.users.models import uuid7


class CarrierAccount(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    provider = models.CharField(max_length=32)
    credentials = models.JSONField(default=dict)
    active = models.BooleanField(default=True)


class Shipment(models.Model):
    PENDING = "PENDING"
    DISPATCHED = "DISPATCHED"
    DELIVERED = "DELIVERED"
    FAILED = "FAILED"
    STATUS_CHOICES = [(PENDING, PENDING), (DISPATCHED, DISPATCHED), (DELIVERED, DELIVERED), (FAILED, FAILED)]

    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="shipments")
    carrier = models.CharField(max_length=32)
    tracking_number = models.CharField(max_length=64, blank=True)
    cost = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default=PENDING)
    created_at = models.DateTimeField(auto_now_add=True)


class ShipmentEvent(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    shipment = models.ForeignKey(Shipment, on_delete=models.CASCADE, related_name="events")
    provider = models.CharField(max_length=32)
    type = models.CharField(max_length=32)
    payload = models.JSONField(default=dict)
    created_at = models.DateTimeField(auto_now_add=True)

