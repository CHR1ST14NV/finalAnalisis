import pytest
from apps.inventory.services.inventory_service import reserve_atomic


def test_reserve_atomic_ok(db, catalog, warehouse, stock):
    sku = catalog["sku"]
    res = reserve_atomic(sku=sku, qty=10, warehouse=warehouse, order_ref="O1")
    assert res.qty == 10


def test_reserve_conflict(db, catalog, warehouse, stock):
    sku = catalog["sku"]
    with pytest.raises(PermissionError):
        reserve_atomic(sku=sku, qty=1000, warehouse=warehouse, order_ref="O1")

