from __future__ import annotations
from decimal import Decimal
from typing import Iterable
from django.db import transaction
from django.shortcuts import get_object_or_404
from apps.catalog.models import SKU
from apps.inventory.models import Warehouse, Reservation
from apps.inventory.services.inventory_service import reserve_atomic, confirm_allocation, release_reservation
from .models import Order, OrderItem


class OrderCreationError(Exception):
    pass


@transaction.atomic
def create_order_and_reserve(*, customer_ref: str, channel: str, items: Iterable[dict], warehouse: Warehouse) -> tuple[Order, list[Reservation]]:
    if not items:
        raise OrderCreationError("no_items")
    order = Order.objects.create(customer_ref=customer_ref, channel=channel, warehouse=warehouse)
    reservations: list[Reservation] = []
    for it in items:
        sku = get_object_or_404(SKU, id=it["sku_id"])
        qty: int = int(it["qty"])  # type: ignore
        price: Decimal = Decimal(it["unit_price"])  # type: ignore
        OrderItem.objects.create(order=order, sku=sku, qty=qty, unit_price=price)
        res = reserve_atomic(sku=sku, qty=qty, warehouse=warehouse, order_ref=str(order.id))
        reservations.append(res)
    return order, reservations


@transaction.atomic
def confirm_order_allocation(*, order: Order) -> None:
    # confirm all reservations
    for res in Reservation.objects.select_for_update().filter(order_ref=str(order.id), status=Reservation.PENDING):
        confirm_allocation(res)
    order.status = Order.CONFIRMED
    order.save(update_fields=["status"])


@transaction.atomic
def compensate_order_reservations(*, order: Order) -> None:
    for res in Reservation.objects.select_for_update().filter(order_ref=str(order.id)).exclude(status=Reservation.CANCELLED):
        release_reservation(res)
    order.status = Order.DRAFT
    order.save(update_fields=["status"])

