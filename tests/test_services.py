import pytest
from django.utils import timezone
from django.contrib.auth import get_user_model
from accounts.models import Role
from partners.models import Distributor, Retailer
from catalog.models import Brand, Category, Product, SKU
from warehouses.models import Warehouse, InventoryBatch
from orders.models import RetailerOrder, OrderItem
from orders.services import allocate_order, pick_and_ship, cancel_order
from datetime import date, timedelta


@pytest.mark.django_db
def test_fefo_allocation():
    brand = Brand.objects.create(name='B')
    cat = Category.objects.create(name='C')
    p = Product.objects.create(name='P', brand=brand, category=cat)
    sku = SKU.objects.create(product=p, code='SKU1')
    wh = Warehouse.objects.create(code='W', name='W')
    # batches: one expiring sooner with less qty
    b1 = InventoryBatch.objects.create(warehouse=wh, sku=sku, lot='L1', expires_at=date.today()+timedelta(days=10), qty_on_hand=2)
    b2 = InventoryBatch.objects.create(warehouse=wh, sku=sku, lot='L2', expires_at=date.today()+timedelta(days=50), qty_on_hand=5)
    dist = Distributor.objects.create(code='D', name='D')
    ret = Retailer.objects.create(code='R', name='R', distributor=dist)
    o = RetailerOrder.objects.create(code='O1', retailer=ret, status=RetailerOrder.PLACED, warehouse=wh)
    it = OrderItem.objects.create(order=o, sku=sku, qty=3, unit_price=10)
    allocate_order(o.id)
    # reservations should take 2 from b1 and 1 from b2
    qtys = sorted([r.qty for r in it.reservations.all()], reverse=True)
    assert sum(qtys) == 3
    assert 2 in qtys and 1 in qtys


@pytest.mark.django_db
def test_pick_and_ship_consumes_stock():
    brand = Brand.objects.create(name='B')
    cat = Category.objects.create(name='C')
    p = Product.objects.create(name='P', brand=brand, category=cat)
    sku = SKU.objects.create(product=p, code='SKU2')
    wh = Warehouse.objects.create(code='W2', name='W2')
    b = InventoryBatch.objects.create(warehouse=wh, sku=sku, lot='L', expires_at=date.today()+timedelta(days=60), qty_on_hand=5)
    dist = Distributor.objects.create(code='D2', name='D2')
    ret = Retailer.objects.create(code='R2', name='R2', distributor=dist)
    o = RetailerOrder.objects.create(code='O2', retailer=ret, status=RetailerOrder.PLACED, warehouse=wh)
    it = OrderItem.objects.create(order=o, sku=sku, qty=3, unit_price=10)
    allocate_order(o.id)
    pick_and_ship(o.id)
    b.refresh_from_db()
    assert b.qty_on_hand == 2
    assert o.status == RetailerOrder.SHIPPED


@pytest.mark.django_db
def test_cancel_releases_reservations():
    brand = Brand.objects.create(name='B3')
    cat = Category.objects.create(name='C3')
    p = Product.objects.create(name='P3', brand=brand, category=cat)
    sku = SKU.objects.create(product=p, code='SKU3')
    wh = Warehouse.objects.create(code='W3', name='W3')
    b = InventoryBatch.objects.create(warehouse=wh, sku=sku, lot='L3', expires_at=date.today()+timedelta(days=60), qty_on_hand=2)
    dist = Distributor.objects.create(code='D3', name='D3')
    ret = Retailer.objects.create(code='R3', name='R3', distributor=dist)
    o = RetailerOrder.objects.create(code='O3', retailer=ret, status=RetailerOrder.PLACED, warehouse=wh)
    it = OrderItem.objects.create(order=o, sku=sku, qty=2, unit_price=10)
    allocate_order(o.id)
    cancel_order(o.id)
    b.refresh_from_db()
    assert b.qty_reserved == 0
    assert o.status == RetailerOrder.CANCELLED

