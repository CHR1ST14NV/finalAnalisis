import uuid
from django.db import models
from django.utils import timezone


def uuid7():
    return uuid.uuid4()


class AuditLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    actor = models.CharField(max_length=120, blank=True)
    ip = models.GenericIPAddressField(null=True, blank=True)
    method = models.CharField(max_length=10)
    path = models.CharField(max_length=255)
    request_body = models.TextField(blank=True)
    response_code = models.IntegerField(default=0)
    created_at = models.DateTimeField(default=timezone.now)
    ttl = models.DateTimeField(null=True, blank=True)

