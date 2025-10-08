from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.utils import timezone
from apps.users.models import Role
from apps.catalog.models import Category, Product, SKU, PriceList, Price, Promotion
from apps.inventory.models import Warehouse, StockBatch
from apps.settlements.models import Policy, Rebate
from apps.orders.models import Order, OrderItem


class Command(BaseCommand):
    help = "Seed demo data: users, warehouses, skus, promos, etc."

    def handle(self, *args, **options):
        U = get_user_model()
        if not U.objects.filter(username="admin").exists():
            U.objects.create_superuser("admin", "admin@example.com", "admin123!")
        # Roles requeridos
        for r in [
            "admin",
            "operador_central",
            "distribuidor",
            "minorista",
            "auditor",
            # aliases en inglés por compatibilidad
            "operator",
            "distributor",
            "retailer",
        ]:
            Role.objects.get_or_create(name=r)
        w1, _ = Warehouse.objects.get_or_create(code="WH1", defaults={"name": "Central"})
        w2, _ = Warehouse.objects.get_or_create(code="WH2", defaults={"name": "Backup"})
        cat, _ = Category.objects.get_or_create(name="Default")
        # create 10 SKUs
        for i in range(1, 11):
            p, _ = Product.objects.get_or_create(name=f"Producto {i}", category=cat)
            sku, _ = SKU.objects.get_or_create(product=p, code=f"SKU{i:03d}")
            StockBatch.objects.get_or_create(sku=sku, warehouse=w1, lot=f"L{i:03d}", defaults={"qty": 100, "available_qty": 100})
        pl, _ = PriceList.objects.get_or_create(name="General")
        for sku in SKU.objects.all()[:10]:
            Price.objects.get_or_create(price_list=pl, sku=sku, valid_from=timezone.now(), defaults={"currency": "USD", "amount": 10})
        for j in range(1, 4):
            Promotion.objects.get_or_create(name=f"Promo {j}", defaults={"percent_off": 5 * j, "active": True, "priority": j, "starts_at": timezone.now(), "ends_at": timezone.now()})
        pol, _ = Policy.objects.get_or_create(name="Default policy")
        Rebate.objects.get_or_create(policy=pol, percent=5, threshold_amount=0)
        # Usuarios demo (2 distribuidores, 3 minoristas)
        for i in range(1, 3):
            u, _ = U.objects.get_or_create(username=f"dist{i}", defaults={"email": f"dist{i}@example.com"})
            u.set_password("demo123!")
            u.save()
            u.roles.add(Role.objects.get(name="distribuidor"))
        for i in range(1, 4):
            u, _ = U.objects.get_or_create(username=f"minor{i}", defaults={"email": f"minor{i}@example.com"})
            u.set_password("demo123!")
            u.save()
            u.roles.add(Role.objects.get(name="minorista"))

        # sample orders
        w = w1
        skus = list(SKU.objects.all()[:2])
        states = [Order.DRAFT, Order.PLACED, Order.CONFIRMED, Order.SHIPPED, Order.DELIVERED]
        for i, st in enumerate(states, start=1):
            o, _ = Order.objects.get_or_create(customer_ref=f"CUST-{i}", warehouse=w, defaults={"status": st})
            for sku in skus:
                OrderItem.objects.get_or_create(order=o, sku=sku, qty=1, unit_price=10)
        self.stdout.write(self.style.SUCCESS("Demo seed completed"))
