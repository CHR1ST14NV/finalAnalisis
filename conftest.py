import pytest
from django.contrib.auth import get_user_model
from apps.catalog.models import Category, Product, SKU
from apps.inventory.models import Warehouse, StockBatch


@pytest.fixture
def user(db):
    U = get_user_model()
    return U.objects.create_user(username="tester", password="x")


@pytest.fixture
def catalog(db):
    cat = Category.objects.create(name="Default")
    p = Product.objects.create(name="Item", category=cat)
    sku = SKU.objects.create(product=p, code="SKU1")
    return {"category": cat, "product": p, "sku": sku}


@pytest.fixture
def warehouse(db):
    return Warehouse.objects.create(code="WH1", name="Main")


@pytest.fixture
def stock(catalog, warehouse):
    sku = catalog["sku"]
    b = StockBatch.objects.create(sku=sku, warehouse=warehouse, lot="L1", qty=100, available_qty=100)
    return b

