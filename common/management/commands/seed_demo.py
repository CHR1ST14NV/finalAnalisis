from django.core.management.base import BaseCommand
from django.utils import timezone
from django.contrib.auth import get_user_model
from accounts.models import Role
from partners.models import Distributor, Retailer
from catalog.models import Brand, Category, Product, SKU
from pricing.models import PriceList, PriceItem
from warehouses.models import Warehouse, InventoryBatch
from orders.models import RetailerOrder, OrderItem
from fulfillment.models import Carrier, Shipment, ShipmentItem
from returns.models import Buyback, BuybackItem
import random
from datetime import timedelta, date


class Command(BaseCommand):
    help = 'Carga datos demo para el dominio omnicanal'

    def handle(self, *args, **opts):
        U = get_user_model()
        roles = ['ADMIN','HQ_OPERATOR','DISTRIBUTOR','RETAILER','WAREHOUSE_OP']
        role_objs = {c: Role.objects.get_or_create(code=c, defaults={'name': c.replace('_',' ').title()})[0] for c in roles}
        admin_email = 'admin@local'
        admin_user, _ = U.objects.get_or_create(username='admin', defaults={'email': admin_email})
        admin_user.set_password('admin12345')
        admin_user.is_superuser = True
        admin_user.is_staff = True
        admin_user.save()
        admin_user.roles.add(role_objs['ADMIN'])

        # Asegurar admin solicitado: cv / 1344
        cv_user, _ = U.objects.get_or_create(username='cv', defaults={'email': 'cv@local'})
        cv_user.set_password('1344')
        cv_user.is_superuser = True
        cv_user.is_staff = True
        cv_user.save()
        cv_user.roles.add(role_objs['ADMIN'])

        wh1, _ = Warehouse.objects.get_or_create(code='WH1', defaults={'name': 'Central'})
        wh2, _ = Warehouse.objects.get_or_create(code='WH2', defaults={'name': 'Backup'})

        dist, _ = Distributor.objects.get_or_create(code='DIST1', defaults={'name': 'Distribuidor Uno'})
        retailers = []
        for i in range(1, 11):
            r, _ = Retailer.objects.get_or_create(code=f'RET{i:02d}', defaults={'name': f'Retailer {i}', 'distributor': dist})
            retailers.append(r)

        brand, _ = Brand.objects.get_or_create(name='Genérica')
        cat, _ = Category.objects.get_or_create(name='Default')
        skus = []
        for i in range(1, 21):
            p, _ = Product.objects.get_or_create(name=f'Producto {i}', brand=brand, category=cat)
            sku, _ = SKU.objects.get_or_create(product=p, code=f'SKU{i:04d}')
            skus.append(sku)

        pl, _ = PriceList.objects.get_or_create(name='General')
        now = timezone.now()
        for sku in skus:
            PriceItem.objects.get_or_create(pricelist=pl, sku=sku, valid_from=now, defaults={'amount': random.randint(5, 20)})

        # batches
        for sku in skus:
            for wh in (wh1, wh2):
                lot = f'L{sku.code[-3:]}{wh.code}'
                exp = date.today() + timedelta(days=random.randint(30, 300))
                InventoryBatch.objects.get_or_create(warehouse=wh, sku=sku, lot=lot, defaults={'expires_at': exp, 'qty_on_hand': 100, 'qty_reserved': 0})

        # Orders in different states
        statuses = [RetailerOrder.DRAFT, RetailerOrder.PLACED, RetailerOrder.ALLOCATED, RetailerOrder.PICKED, RetailerOrder.SHIPPED, RetailerOrder.DELIVERED]
        for i in range(1, 21):
            o, _ = RetailerOrder.objects.get_or_create(code=f'ORD{i:05d}', retailer=random.choice(retailers), defaults={'status': random.choice(statuses), 'warehouse': random.choice([wh1, wh2])})
            for sku in random.sample(skus, 2):
                OrderItem.objects.get_or_create(order=o, sku=sku, defaults={'qty': random.randint(1, 3), 'unit_price': 10})

        car, _ = Carrier.objects.get_or_create(code='CARR1', defaults={'name': 'Carrier X'})
        # Some shipments for delivered orders
        for o in RetailerOrder.objects.filter(status__in=[RetailerOrder.SHIPPED, RetailerOrder.DELIVERED])[:5]:
            sh, _ = Shipment.objects.get_or_create(code=f'SH{o.code[-4:]}', order=o, defaults={'carrier': car, 'tracking': f'TRK{o.code[-6:]}', 'status': Shipment.DISPATCHED})
            for it in o.items.all():
                ShipmentItem.objects.get_or_create(shipment=sh, order_item=it, defaults={'qty': it.qty})

        # Buybacks near expiry
        bb = Buyback.objects.create(retailer=random.choice(retailers))
        for b in InventoryBatch.objects.all()[:3]:
            BuybackItem.objects.create(buyback=bb, batch=b, qty=1)

        self.stdout.write(self.style.SUCCESS('Seed demo completo.'))
