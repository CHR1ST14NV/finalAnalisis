from django.shortcuts import get_object_or_404
from rest_framework import status, views
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from apps.catalog.models import SKU
from .models import Warehouse, Reservation
from .serializers import (
    WarehouseSerializer,
    ReservationSerializer,
    CreateReservationSerializer,
)
from .services.inventory_service import availability_by_sku, reserve_atomic, confirm_allocation
from drf_spectacular.utils import extend_schema, OpenApiExample


class AvailabilityView(views.APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        examples=[OpenApiExample("Availability", value={"sku": "<uuid>", "warehouse": "<uuid>"})]
    )
    def get(self, request):
        sku_id = request.query_params.get("sku")
        wh_id = request.query_params.get("warehouse")
        sku = get_object_or_404(SKU, id=sku_id)
        warehouse = Warehouse.objects.filter(id=wh_id).first() if wh_id else None
        data = [vars(a) for a in availability_by_sku(sku, warehouse)]
        return Response(data)


class ReservationView(views.APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(
        request=CreateReservationSerializer,
        responses=ReservationSerializer,
        examples=[
            OpenApiExample(
                "Create reservation",
                value={"sku_id": "<uuid>", "qty": 2, "warehouse_preference": "<uuid>", "order_ref": "O123"},
            )
        ],
    )
    def post(self, request):
        s = CreateReservationSerializer(data=request.data)
        s.is_valid(raise_exception=True)
        sku = get_object_or_404(SKU, id=s.validated_data["sku_id"])
        qty = s.validated_data["qty"]
        wh_pref = s.validated_data.get("warehouse_preference")
        order_ref = s.validated_data["order_ref"]
        if wh_pref:
            warehouse = get_object_or_404(Warehouse, id=wh_pref)
        else:
            warehouse = Warehouse.objects.order_by("code").first()
        try:
            res = reserve_atomic(sku=sku, qty=qty, warehouse=warehouse, order_ref=order_ref)
        except PermissionError:
            return Response({"detail": "Insufficient stock"}, status=status.HTTP_409_CONFLICT)
        return Response(ReservationSerializer(res).data, status=status.HTTP_201_CREATED)


class ReservationConfirmView(views.APIView):
    permission_classes = [IsAuthenticated]

    @extend_schema(examples=[OpenApiExample("Confirm", value={})])
    def post(self, request, pk):
        res = get_object_or_404(Reservation, id=pk)
        confirm_allocation(res)
        return Response(ReservationSerializer(res).data)
