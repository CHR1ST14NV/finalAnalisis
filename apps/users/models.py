import uuid
from django.contrib.auth.models import AbstractUser
from django.db import models


def uuid7() -> uuid.UUID:
    # simplified UUIDv7 placeholder using uuid4; replace with real lib if needed
    return uuid.uuid4()


class Role(models.Model):
    name = models.CharField(max_length=50, unique=True)
    description = models.CharField(max_length=255, blank=True)

    def __str__(self) -> str:
        return self.name


class Permission(models.Model):
    code = models.CharField(max_length=100, unique=True)
    description = models.CharField(max_length=255, blank=True)

    def __str__(self) -> str:
        return self.code


class User(AbstractUser):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    roles = models.ManyToManyField(Role, blank=True)
    api_only = models.BooleanField(default=False)


class ApiKey(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="api_keys")
    name = models.CharField(max_length=100)
    key_hash = models.CharField(max_length=128)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField(null=True, blank=True)
    last_used_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        indexes = [models.Index(fields=["user", "created_at"])]


class IdempotencyKey(models.Model):
    key = models.CharField(max_length=128, unique=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    method = models.CharField(max_length=10)
    path = models.CharField(max_length=255)
    payload_hash = models.CharField(max_length=128)
    response_code = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        indexes = [models.Index(fields=["path", "created_at"])]

