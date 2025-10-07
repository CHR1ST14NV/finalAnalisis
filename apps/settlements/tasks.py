from __future__ import annotations
from decimal import Decimal
from django.utils import timezone
from celery import shared_task
from .models import SettlementRun, SettlementLine, Policy, Rebate
from apps.orders.models import Order


@shared_task
def run_settlement(period: str) -> str:
    run = SettlementRun.objects.create(period=period)
    policy = Policy.objects.filter(active=True).first()
    rebate_percent = Decimal("0")
    if policy:
        r = Rebate.objects.filter(policy=policy).first()
        if r:
            rebate_percent = r.percent
    for order in Order.objects.filter(status=Order.DELIVERED):
        amount = sum([i.unit_price * i.qty for i in order.items.all()])
        rebate = (amount * rebate_percent) / Decimal("100")
        SettlementLine.objects.create(run=run, order=order, amount=amount, rebate_amount=rebate)
    run.finished_at = timezone.now()
    run.save(update_fields=["finished_at"])
    return str(run.id)

