from rest_framework import serializers
from apps.catalog.serializers import SKUSerializer
from .models import Order, OrderItem


class OrderItemCreateSerializer(serializers.Serializer):
    sku_id = serializers.UUIDField()
    qty = serializers.IntegerField(min_value=1)
    unit_price = serializers.DecimalField(max_digits=12, decimal_places=2)


class OrderCreateSerializer(serializers.Serializer):
    customer_ref = serializers.CharField(max_length=64)
    channel = serializers.CharField(max_length=32)
    items = OrderItemCreateSerializer(many=True)
    warehouse_id = serializers.UUIDField(required=False)


class OrderItemSerializer(serializers.ModelSerializer):
    sku = SKUSerializer(read_only=True)

    class Meta:
        model = OrderItem
        fields = ["id", "sku", "qty", "unit_price"]


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)

    class Meta:
        model = Order
        fields = [
            "id",
            "status",
            "customer_ref",
            "channel",
            "warehouse",
            "created_at",
            "updated_at",
            "items",
        ]

