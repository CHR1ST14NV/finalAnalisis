import pytest
from decimal import Decimal
from apps.catalog.models import Category, Product, SKU
from apps.inventory.models import Warehouse, StockBatch, Reservation
from apps.orders.services import create_order_and_reserve, confirm_order_allocation


@pytest.mark.django_db
def test_create_order_and_reserve():
    cat = Category.objects.create(name="X")
    p = Product.objects.create(name="P", category=cat)
    sku = SKU.objects.create(product=p, code="S1")
    wh = Warehouse.objects.create(code="W1", name="W1")
    StockBatch.objects.create(sku=sku, warehouse=wh, lot="L1", qty=10, available_qty=10)

    order, reservations = create_order_and_reserve(
        customer_ref="C001",
        channel="B2B",
        items=[{"sku_id": str(sku.id), "qty": 2, "unit_price": str(Decimal('10.00'))}],
        warehouse=wh,
    )
    assert order.items.count() == 1
    assert len(reservations) == 1
    assert reservations[0].status == Reservation.PENDING

    confirm_order_allocation(order=order)
    reservations[0].refresh_from_db()
    assert reservations[0].status == Reservation.CONFIRMED

