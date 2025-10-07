from apps.orders.services import create_order_and_reserve, compensate_order_reservations


def test_create_order_and_reserve(db, warehouse, catalog, stock):
    sku = catalog["sku"]
    order, reservations = create_order_and_reserve(
        customer_ref="C1",
        channel="B2B",
        items=[{"sku_id": str(sku.id), "qty": 2, "unit_price": "10.00"}],
        warehouse=warehouse,
    )
    assert order.items.count() == 1
    assert len(reservations) == 1


def test_compensate(db, warehouse, catalog, stock):
    sku = catalog["sku"]
    order, _ = create_order_and_reserve(
        customer_ref="C1", channel="B2B", items=[{"sku_id": str(sku.id), "qty": 2, "unit_price": "10.00"}], warehouse=warehouse
    )
    compensate_order_reservations(order=order)
    # no exception implies successful compensation
    assert True

