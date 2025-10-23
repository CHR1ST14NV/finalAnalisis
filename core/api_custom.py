from __future__ import annotations
from datetime import datetime
from decimal import Decimal
from typing import Any, Dict, List

from django.core.paginator import Paginator
from django.db import transaction
from django.utils import timezone
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from catalog.models import Product, SKU
from pricing.models import PriceList, PriceItem
from orders.models import RetailerOrder, OrderItem
from partners.models import Retailer
from warehouses.models import Warehouse, InventoryBatch


class ProductsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        q = request.query_params.get("q")
        page = int(request.query_params.get("page") or 1)
        qs = Product.objects.all().order_by("id")
        if q:
            qs = qs.filter(name__icontains=q)

        paginator = Paginator(qs, 20)
        page_obj = paginator.get_page(page)
        now = timezone.now()

        # Preload related SKUs for products in page
        product_ids = [p.id for p in page_obj.object_list]
        skus_by_product: Dict[int, List[SKU]] = {}
        for s in SKU.objects.filter(product_id__in=product_ids).order_by("id"):
            skus_by_product.setdefault(s.product_id, []).append(s)

        # PriceList optional
        pl = PriceList.objects.filter(is_active=True).order_by("id").first()

        def price_for_sku(sku: SKU) -> Dict[str, str] | None:
            if not pl:
                return None
            pi = (
                PriceItem.objects.filter(pricelist=pl, sku=sku, valid_from__lte=now)
                .order_by("-valid_from")
                .first()
            )
            if not pi:
                return None
            currency = getattr(pl, "currency", "USD")
            return {"currency": currency, "amount": str(pi.amount)}

        results: List[Dict[str, Any]] = []
        for p in page_obj.object_list:
            skus = skus_by_product.get(p.id, [])
            primary = skus[0] if skus else None
            results.append(
                {
                    "id": str(p.id),
                    "name": p.name,
                    "description": "",
                    "primary_sku_id": str(primary.id) if primary else None,
                    "price": price_for_sku(primary) if primary else None,
                }
            )

        return Response({"count": paginator.count, "results": results})


class OrdersView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        # Simplified list for UI
        data = [
            {
                "id": str(o.id),
                "status": o.status,
                "customer_ref": o.code,
                "created_at": o.created_at.isoformat(),
            }
            for o in RetailerOrder.objects.order_by("-created_at")[:200]
        ]
        return Response(data)

    @transaction.atomic
    def post(self, request):
        payload = request.data or {}
        customer_ref = payload.get("customer_ref") or ""
        channel = payload.get("channel") or "B2B"
        items = payload.get("items") or []
        warehouse_id = payload.get("warehouse_id")

        if not items:
            return Response({"detail": "items vacíos"}, status=400)

        # Pick a retailer (demo) – in real life this comes from the session or payload
        retailer = Retailer.objects.order_by("id").first()
        if not retailer:
            return Response({"detail": "No hay retailers configurados"}, status=400)

        wh = None
        if warehouse_id:
            try:
                wh = Warehouse.objects.get(id=int(warehouse_id))
            except Exception:
                pass

        # Generate order code if not provided
        code = customer_ref or f"ORD{int(datetime.now().timestamp())}"
        order = RetailerOrder.objects.create(code=code, retailer=retailer, status=RetailerOrder.PLACED, warehouse=wh)

        for it in items:
            try:
                sku_id = int(it.get("sku_id"))
                qty = int(it.get("qty"))
                unit_price = Decimal(str(it.get("unit_price") or "0"))
            except Exception:
                return Response({"detail": "Item inválido"}, status=400)
            sku = SKU.objects.filter(id=sku_id).first()
            if not sku:
                return Response({"detail": f"SKU {sku_id} no existe"}, status=400)
            OrderItem.objects.create(order=order, sku=sku, qty=qty, unit_price=unit_price)

        return Response({
            "id": str(order.id),
            "status": order.status,
            "customer_ref": order.code,
            "created_at": order.created_at.isoformat(),
        }, status=201)


class OrderConfirmView(APIView):
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def post(self, request, pk: int):
        try:
            o = RetailerOrder.objects.get(id=pk)
        except RetailerOrder.DoesNotExist:
            return Response({"detail": "No encontrado"}, status=404)
        # For demo, move PLACED -> ALLOCATED; otherwise keep status
        if o.status == RetailerOrder.PLACED:
            o.status = RetailerOrder.ALLOCATED
            o.save(update_fields=["status", "updated_at"])
        return Response({"status": o.status})


class KPIsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        total = RetailerOrder.objects.count()
        delivered = RetailerOrder.objects.filter(status=RetailerOrder.DELIVERED).count()
        fill_rate = (delivered / total) if total else 0.0

        stock_total = InventoryBatch.objects.aggregate(total_qty=Decimal("0") + (0)).get("total_qty")
        if stock_total is None:
            stock_total = 0

        # lead time approximation using updated_at as proxy
        lead_times: List[float] = []
        for o in RetailerOrder.objects.filter(status=RetailerOrder.DELIVERED).only("created_at", "updated_at")[:500]:
            if o.created_at and o.updated_at:
                lead_times.append((o.updated_at - o.created_at).total_seconds())
        lead_times.sort()
        p50 = percentile(lead_times, 50)
        p95 = percentile(lead_times, 95)

        return Response({
            "fill_rate": fill_rate,
            "orders_total": total,
            "delivered": delivered,
            "stock_total": stock_total or 0,
            "lead_time_p50_seconds": p50,
            "lead_time_p95_seconds": p95,
        })


def percentile(values: List[float], p: int) -> float:
    if not values:
        return 0.0
    k = (len(values) - 1) * (p / 100)
    f = int(k)
    c = min(f + 1, len(values) - 1)
    if f == c:
        return values[f]
    d0 = values[f] * (c - k)
    d1 = values[c] * (k - f)
    return d0 + d1

