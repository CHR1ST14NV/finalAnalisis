import uuid
from decimal import Decimal
from django.db import models
from apps.users.models import uuid7
from apps.orders.models import Order


class Policy(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    name = models.CharField(max_length=120)
    description = models.TextField(blank=True)
    active = models.BooleanField(default=True)


class Rebate(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    policy = models.ForeignKey(Policy, on_delete=models.CASCADE, related_name="rebates")
    percent = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    threshold_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0)


class SettlementRun(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    period = models.CharField(max_length=32)
    started_at = models.DateTimeField(auto_now_add=True)
    finished_at = models.DateTimeField(null=True, blank=True)


class SettlementLine(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    run = models.ForeignKey(SettlementRun, on_delete=models.CASCADE, related_name="lines")
    order = models.ForeignKey(Order, on_delete=models.PROTECT)
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    rebate_amount = models.DecimalField(max_digits=12, decimal_places=2, default=0)

