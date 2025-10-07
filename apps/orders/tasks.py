from __future__ import annotations
from celery import shared_task
from django.db import transaction
from .models import Order
from .services import confirm_order_allocation, compensate_order_reservations
from apps.fulfillment.services import create_shipment_for_order


@shared_task(bind=True, autoretry_for=(Exception,), retry_backoff=True, retry_kwargs={"max_retries": 5})
def process_order_fulfillment(self, order_id: str):
    order = Order.objects.get(id=order_id)
    try:
        with transaction.atomic():
            confirm_order_allocation(order=order)
        # Ship via best carrier
        create_shipment_for_order(order)
        order.status = Order.ALLOCATED
        order.save(update_fields=["status"])
    except Exception:
        compensate_order_reservations(order=order)
        raise

