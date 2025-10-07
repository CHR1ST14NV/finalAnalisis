from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Sum
from apps.orders.models import Order
from apps.inventory.models import StockBatch


class KPIsView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        orders_total = Order.objects.count()
        delivered = Order.objects.filter(status=Order.DELIVERED).count()
        fill_rate = delivered / orders_total if orders_total else 0
        agg = StockBatch.objects.aggregate(total=Sum("qty"))
        stock = agg.get("total") or 0
        return Response({
            "fill_rate": fill_rate,
            "orders_total": orders_total,
            "delivered": delivered,
            "stock_total": stock,
        })
