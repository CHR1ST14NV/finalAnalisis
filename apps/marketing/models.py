import uuid
from django.db import models
from apps.users.models import uuid7


class Segment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    name = models.CharField(max_length=100)
    rule = models.JSONField(default=dict)


class Campaign(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    name = models.CharField(max_length=120)
    metadata = models.JSONField(default=dict)


class Coupon(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    code = models.CharField(max_length=32, unique=True)
    percent_off = models.DecimalField(max_digits=5, decimal_places=2)
    active = models.BooleanField(default=True)

