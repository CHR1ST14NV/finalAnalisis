from django.db import models
from common.models import AbstractAuditMixin
from partners.models import Distributor, Retailer
from orders.models import RetailerOrder


class CreditTerms(AbstractAuditMixin):
    DISTRIBUTOR = 'DISTRIBUTOR'
    RETAILER = 'RETAILER'
    PARTNER_CHOICES = [(DISTRIBUTOR, DISTRIBUTOR), (RETAILER, RETAILER)]
    partner_type = models.CharField(max_length=16, choices=PARTNER_CHOICES)
    partner_id = models.BigIntegerField()
    credit_limit = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    payment_terms_days = models.IntegerField(default=0)


class Settlement(AbstractAuditMixin):
    partner_type = models.CharField(max_length=16, choices=CreditTerms.PARTNER_CHOICES)
    partner_id = models.BigIntegerField()
    period = models.CharField(max_length=16)


class SettlementLine(AbstractAuditMixin):
    settlement = models.ForeignKey(Settlement, on_delete=models.CASCADE, related_name='lines')
    order = models.ForeignKey(RetailerOrder, on_delete=models.PROTECT)
    amount = models.DecimalField(max_digits=12, decimal_places=2)

