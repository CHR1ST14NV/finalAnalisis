from datetime import date, timedelta
from django.db import transaction
from warehouses.models import InventoryBatch
from .models import RetailerOrder, OrderItem, Reservation, Allocation


@transaction.atomic
def allocate_order(order_id: int, safety_days: int = 0) -> None:
    order = RetailerOrder.objects.select_for_update().get(id=order_id)
    if order.status not in [RetailerOrder.PLACED, RetailerOrder.DRAFT]:
        return
    today = date.today() + timedelta(days=safety_days)
    for item in OrderItem.objects.select_for_update().filter(order=order):
        to_alloc = item.qty
        # FEFO: batches by nearest expiry (ignoring expired or within safety_days)
        batches = (
            InventoryBatch.objects.select_for_update()
            .filter(warehouse=order.warehouse, sku=item.sku, qty_on_hand__gt=0)
            .exclude(expires_at__lt=today)
            .order_by('expires_at', 'id')
        )
        for b in batches:
            if to_alloc <= 0:
                break
            available = b.qty_on_hand - b.qty_reserved
            if available <= 0:
                continue
            take = min(available, to_alloc)
            Reservation.objects.create(order_item=item, batch=b, qty=take)
            b.qty_reserved += take
            b.save(update_fields=['qty_reserved'])
            to_alloc -= take
        if to_alloc > 0:
            raise ValueError('insufficient_stock')
    order.status = RetailerOrder.ALLOCATED
    order.save(update_fields=['status'])


@transaction.atomic
def pick_and_ship(order_id: int, carrier_code: str | None = None) -> None:
    from fulfillment.models import Carrier, Shipment, ShipmentItem

    order = RetailerOrder.objects.select_for_update().get(id=order_id)
    if order.status not in [RetailerOrder.ALLOCATED, RetailerOrder.PICKED]:
        return
    # Convert reservations into allocations and decrement stock
    for item in OrderItem.objects.select_for_update().filter(order=order):
        for res in item.reservations.select_for_update():
            Allocation.objects.create(order_item=item, batch=res.batch, qty=res.qty)
            # consume stock
            b = res.batch
            b.qty_reserved -= res.qty
            b.qty_on_hand -= res.qty
            if b.qty_reserved < 0 or b.qty_on_hand < 0:
                raise ValueError('negative_stock')
            b.save(update_fields=['qty_reserved','qty_on_hand'])
            res.delete()
    order.status = RetailerOrder.PICKED
    order.save(update_fields=['status'])

    car = None
    if carrier_code:
        car = Carrier.objects.filter(code=carrier_code).first()
    sh = Shipment.objects.create(code=f'SH{order.code}', order=order, carrier=car, tracking=f'TRK{order.code}', status=Shipment.DISPATCHED)
    for it in order.items.all():
        ShipmentItem.objects.create(shipment=sh, order_item=it, qty=it.qty)
    order.status = RetailerOrder.SHIPPED
    order.save(update_fields=['status'])


@transaction.atomic
def cancel_order(order_id: int) -> None:
    order = RetailerOrder.objects.select_for_update().get(id=order_id)
    # Release reservations
    for item in order.items.all():
        for res in item.reservations.select_for_update():
            b = res.batch
            b.qty_reserved -= res.qty
            if b.qty_reserved < 0:
                b.qty_reserved = 0
            b.save(update_fields=['qty_reserved'])
            res.delete()
    order.status = RetailerOrder.CANCELLED
    order.save(update_fields=['status'])


def near_expiry_buyback(days: int = 30):
    from returns.models import Buyback, BuybackItem
    from partners.models import Retailer

    cutoff = date.today() + timedelta(days=days)
    bb = Buyback.objects.create(retailer=Retailer.objects.first())
    for b in InventoryBatch.objects.filter(expires_at__lte=cutoff).order_by('expires_at')[:10]:
        if b.qty_on_hand > 0:
            BuybackItem.objects.create(buyback=bb, batch=b, qty=min(1, b.qty_on_hand))
    return bb.id

