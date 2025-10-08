import pytest
from django.utils import timezone
from apps.catalog.models import Category, Product, SKU
from apps.inventory.models import Warehouse, StockBatch, Reservation
from apps.inventory.services.inventory_service import reserve_atomic, confirm_allocation, release_reservation


@pytest.mark.django_db
def test_reserve_and_confirm_allocation():
    cat = Category.objects.create(name="X")
    p = Product.objects.create(name="P", category=cat)
    sku = SKU.objects.create(product=p, code="S1")
    wh = Warehouse.objects.create(code="W1", name="W1")
    StockBatch.objects.create(sku=sku, warehouse=wh, lot="L1", qty=10, available_qty=10, received_at=timezone.now())

    res = reserve_atomic(sku=sku, qty=3, warehouse=wh, order_ref="O1")
    assert isinstance(res, Reservation)
    assert res.qty == 3
    confirm_allocation(res)
    res.refresh_from_db()
    assert res.status == Reservation.CONFIRMED


@pytest.mark.django_db
def test_release_reservation_returns_stock():
    cat = Category.objects.create(name="X")
    p = Product.objects.create(name="P", category=cat)
    sku = SKU.objects.create(product=p, code="S2")
    wh = Warehouse.objects.create(code="W2", name="W2")
    StockBatch.objects.create(sku=sku, warehouse=wh, lot="L1", qty=5, available_qty=5, received_at=timezone.now())
    res = reserve_atomic(sku=sku, qty=2, warehouse=wh, order_ref="O2")
    release_reservation(res)
    res.refresh_from_db()
    assert res.status == Reservation.CANCELLED

