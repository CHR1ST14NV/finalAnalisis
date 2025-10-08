from __future__ import annotations
from datetime import datetime
from urllib.parse import urlencode
from django.conf import settings
from django.db.models import Sum, Q
from django.utils.dateparse import parse_datetime
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from apps.audit.models import AuditLog
from apps.inventory.models import StockBatch, Warehouse
from apps.orders.models import Order
import httpx


class KPIsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        start_str = request.query_params.get("start")
        end_str = request.query_params.get("end")
        warehouse_id = request.query_params.get("warehouse")
        start: datetime | None = parse_datetime(start_str) if start_str else None
        end: datetime | None = parse_datetime(end_str) if end_str else None

        order_q = Q()
        if start:
            order_q &= Q(created_at__gte=start)
        if end:
            order_q &= Q(created_at__lte=end)
        if warehouse_id:
            order_q &= Q(warehouse_id=warehouse_id)

        orders_total = Order.objects.filter(order_q).count()
        delivered = Order.objects.filter(order_q & Q(status=Order.DELIVERED)).count()
        fill_rate = delivered / orders_total if orders_total else 0.0

        stock_qs = StockBatch.objects.all()
        if warehouse_id:
            stock_qs = stock_qs.filter(warehouse_id=warehouse_id)
        stock_total = stock_qs.aggregate(total=Sum("qty"))['total'] or 0

        # Simple lead time approximation: delivered orders created within range
        lead_times = []
        for o in Order.objects.filter(order_q & Q(status=Order.DELIVERED)).only("created_at", "updated_at")[:500]:
            # updated_at used as proxy for delivered timestamp; real impl: dedicated delivered_at
            if o.updated_at and o.created_at:
                lead_times.append((o.updated_at - o.created_at).total_seconds())
        lead_time_p50 = percentile(lead_times, 50)
        lead_time_p95 = percentile(lead_times, 95)

        # Aging: days to expiry weighted by qty (simple avg)
        aging_days = []
        for b in stock_qs.only("expires_at", "qty")[:1000]:
            if b.expires_at:
                aging_days.append((b.expires_at - b.received_at).days)
        aging_avg_days = (sum(aging_days) / len(aging_days)) if aging_days else 0

        # Throughput & error rate based on audit logs in last hour
        http_q = Q()
        if start:
            http_q &= Q(created_at__gte=start)
        if end:
            http_q &= Q(created_at__lte=end)
        total_req = AuditLog.objects.filter(http_q).count()
        error_req = AuditLog.objects.filter(http_q & Q(response_code__gte=400)).count()
        error_rate = (error_req / total_req) if total_req else 0

        p95_latency = None
        if settings.PROMETHEUS_URL:
            try:
                p95_latency = query_prometheus_p95(settings.PROMETHEUS_URL)
            except Exception:
                p95_latency = None

        return Response({
            "fill_rate": fill_rate,
            "orders_total": orders_total,
            "delivered": delivered,
            "stock_total": stock_total,
            "lead_time_p50_seconds": lead_time_p50,
            "lead_time_p95_seconds": lead_time_p95,
            "aging_avg_days": aging_avg_days,
            "error_rate": error_rate,
            "p95_latency_seconds": p95_latency,
        })


def percentile(values: list[float], p: int) -> float:
    if not values:
        return 0.0
    values = sorted(values)
    k = (len(values) - 1) * (p / 100)
    f = int(k)
    c = min(f + 1, len(values) - 1)
    if f == c:
        return values[int(k)]
    d0 = values[f] * (c - k)
    d1 = values[c] * (k - f)
    return d0 + d1


def query_prometheus_p95(base_url: str) -> float | None:
    # histogram_quantile over the django_http_request_latency_seconds_bucket
    query = "histogram_quantile(0.95, sum(rate(django_http_request_latency_seconds_bucket[5m])) by (le))"
    url = f"{base_url.rstrip('/')}/api/v1/query?{urlencode({'query': query})}"
    with httpx.Client(timeout=2.0) as client:
        r = client.get(url)
        r.raise_for_status()
        data = r.json()
        result = data.get("data", {}).get("result", [])
        if result:
            try:
                return float(result[0]["value"][1])
            except Exception:
                return None
    return None
