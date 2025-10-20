from django.contrib.auth.models import AbstractUser
from django.db import models


class Role(models.Model):
    ADMIN = 'ADMIN'
    HQ_OPERATOR = 'HQ_OPERATOR'
    DISTRIBUTOR = 'DISTRIBUTOR'
    RETAILER = 'RETAILER'
    WAREHOUSE_OP = 'WAREHOUSE_OP'
    CODES = [ADMIN, HQ_OPERATOR, DISTRIBUTOR, RETAILER, WAREHOUSE_OP]

    code = models.CharField(max_length=32, unique=True)
    name = models.CharField(max_length=64)

    def __str__(self) -> str:
        return self.code


class User(AbstractUser):
    email = models.EmailField(unique=True)
    roles = models.ManyToManyField(Role, blank=True, related_name='users')
    distributor = models.ForeignKey('partners.Distributor', null=True, blank=True, on_delete=models.SET_NULL)
    retailer = models.ForeignKey('partners.Retailer', null=True, blank=True, on_delete=models.SET_NULL)

    def has_role(self, *codes: str) -> bool:
        return self.is_superuser or self.roles.filter(code__in=codes).exists()
