from __future__ import annotations
import contextlib
from dataclasses import dataclass
from datetime import timedelta
from typing import Optional
from django.conf import settings
from django.core.cache import cache
from django.db import transaction, models
from django.utils import timezone

from apps.catalog.models import SKU
from apps.inventory.models import Reservation, StockBatch, StockLedger, Warehouse


@dataclass
class Availability:
    sku_id: str
    warehouse_id: str
    available: int


def _lock_key(sku_id: str, wh_id: str) -> str:
    return f"lock:inv:{sku_id}:{wh_id}"


@contextlib.contextmanager
def redis_lock(key: str, ttl_ms: int = 10_000):
    client = cache.client.get_client(write=True)
    token = None
    try:
        token = client.set(key, "1", nx=True, px=ttl_ms)
        if not token:
            raise RuntimeError("Resource locked")
        yield
    finally:
        # best-effort release
        with contextlib.suppress(Exception):
            client.delete(key)


def availability_by_sku(sku: SKU, warehouse: Optional[Warehouse] = None) -> list[Availability]:
    qs = StockBatch.objects.filter(sku=sku)
    if warehouse:
        qs = qs.filter(warehouse=warehouse)
    qs = qs.values("warehouse_id").order_by().annotate(available_sum=models.Sum("available_qty"))
    return [Availability(str(sku.id), str(r["warehouse_id"]), r["available_sum"] or 0) for r in qs]


@transaction.atomic
def reserve_atomic(*, sku: SKU, qty: int, warehouse: Warehouse, order_ref: str, ttl_seconds: int = 900) -> Reservation:
    if qty <= 0:
        raise ValueError("qty must be > 0")
    key = _lock_key(str(sku.id), str(warehouse.id))
    with redis_lock(key):
        # compute availability
        total_avail = (
            StockBatch.objects.filter(sku=sku, warehouse=warehouse).aggregate(s=models.Sum("available_qty"))[
                "s"
            ]
            or 0
        )
        if total_avail < qty:
            raise PermissionError("insufficient_stock")
        # reserve from FEFO batches: soonest expiry first
        to_reserve = qty
        batches = (
            StockBatch.objects.select_for_update()
            .filter(sku=sku, warehouse=warehouse, available_qty__gt=0)
            .order_by("expires_at", "received_at")
        )
        for b in batches:
            if to_reserve <= 0:
                break
            take = min(b.available_qty, to_reserve)
            b.available_qty -= take
            b.save(update_fields=["available_qty"])
            StockLedger.objects.create(
                sku=sku, warehouse=warehouse, event=StockLedger.RESERVE, delta=-take, batch=b, ref=order_ref
            )
            to_reserve -= take
        if to_reserve != 0:
            # invariant break; should not happen due to earlier check
            raise RuntimeError("reservation_invariant_broken")
        res = Reservation.objects.create(
            sku=sku,
            warehouse=warehouse,
            qty=qty,
            status=Reservation.PENDING,
            ttl_expires_at=timezone.now() + timedelta(seconds=ttl_seconds),
            order_ref=order_ref,
        )
        return res


@transaction.atomic
def confirm_allocation(reservation: Reservation) -> None:
    if reservation.status != Reservation.PENDING:
        return
    # convert reservation RESERVE into ALLOCATE; batches already decremented available_qty,
    # here we just ledger a corresponding ALLOCATE for traceability
    StockLedger.objects.create(
        sku=reservation.sku,
        warehouse=reservation.warehouse,
        event=StockLedger.ALLOCATE,
        delta=0,
        ref=reservation.order_ref,
    )
    reservation.status = Reservation.CONFIRMED
    reservation.save(update_fields=["status"])


@transaction.atomic
def release_reservation(reservation: Reservation) -> None:
    if reservation.status not in {Reservation.PENDING, Reservation.CONFIRMED}:
        return
    # Return qty to earliest batches (reverse of reserve distribution is not tracked per batch here for brevity)
    # Simplified: add back to the oldest batches
    remaining = reservation.qty
    batches = (
        StockBatch.objects.select_for_update()
        .filter(sku=reservation.sku, warehouse=reservation.warehouse)
        .order_by("received_at")
    )
    for b in batches:
        if remaining <= 0:
            break
        b.available_qty += remaining
        b.save(update_fields=["available_qty"])
        StockLedger.objects.create(
            sku=reservation.sku,
            warehouse=reservation.warehouse,
            event=StockLedger.RELEASE,
            delta=remaining,
            batch=b,
            ref=reservation.order_ref,
        )
        remaining = 0
    reservation.status = Reservation.CANCELLED
    reservation.save(update_fields=["status"])
