from rest_framework import serializers
from apps.catalog.serializers import SKUSerializer
from .models import Warehouse, Reservation


class WarehouseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Warehouse
        fields = ["id", "code", "name", "latitude", "longitude"]


class ReservationSerializer(serializers.ModelSerializer):
    sku = SKUSerializer(read_only=True)

    class Meta:
        model = Reservation
        fields = ["id", "sku", "warehouse", "qty", "status", "ttl_expires_at", "order_ref"]
        read_only_fields = ["id", "status", "ttl_expires_at"]


class CreateReservationSerializer(serializers.Serializer):
    sku_id = serializers.UUIDField()
    qty = serializers.IntegerField(min_value=1)
    warehouse_preference = serializers.UUIDField(required=False)
    order_ref = serializers.CharField(max_length=64)

