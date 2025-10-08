from django.shortcuts import get_object_or_404
from rest_framework import status, views
from rest_framework.permissions import IsAuthenticated
from apps.users.permissions import HasRole
from rest_framework.response import Response
from apps.inventory.models import Warehouse
from .models import Order
from .serializers import OrderCreateSerializer, OrderSerializer
from .services import create_order_and_reserve
from .tasks import process_order_fulfillment
from drf_spectacular.utils import extend_schema, OpenApiExample


class OrderView(views.APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        request=OrderCreateSerializer,
        responses=OrderSerializer,
        examples=[
            OpenApiExample(
                "Create order",
                value={
                    "customer_ref": "CUST-001",
                    "channel": "B2B",
                    "items": [{"sku_id": "<uuid>", "qty": 2, "unit_price": "10.00"}],
                },
            )
        ],
    )
    def post(self, request):
        # RBAC: solo roles de canal pueden crear
        role_guard = HasRole()
        role_guard.required_roles = ["admin", "operador_central", "operator", "distribuidor", "distributor", "minorista", "retailer"]
        if not role_guard.has_permission(request, self):
            return Response({"detail": "forbidden"}, status=status.HTTP_403_FORBIDDEN)
        s = OrderCreateSerializer(data=request.data)
        s.is_valid(raise_exception=True)
        wh = (
            get_object_or_404(Warehouse, id=s.validated_data["warehouse_id"]) if s.validated_data.get("warehouse_id") else Warehouse.objects.order_by("code").first()
        )
        order, _reservations = create_order_and_reserve(
            customer_ref=s.validated_data["customer_ref"],
            channel=s.validated_data["channel"],
            items=s.validated_data["items"],
            warehouse=wh,
        )
        return Response(OrderSerializer(order).data, status=status.HTTP_201_CREATED)

    @extend_schema(responses=OrderSerializer)
    def get(self, request):
        qs = Order.objects.select_related("warehouse").order_by("-created_at")[:50]
        data = [OrderSerializer(o).data for o in qs]
        return Response(data)


class OrderConfirmView(views.APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        examples=[OpenApiExample("Confirm", value={})],
        responses={200: {"type": "object", "properties": {"status": {"type": "string"}}}},
    )
    def post(self, request, pk):
        order = get_object_or_404(Order, id=pk)
        # kick off async fulfillment saga
        process_order_fulfillment.delay(str(order.id))
        return Response({"status": "queued"})
