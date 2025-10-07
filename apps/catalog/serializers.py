from rest_framework import serializers
from .models import Product, SKU, Category, Promotion


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name", "parent"]


class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer(read_only=True)

    class Meta:
        model = Product
        fields = ["id", "name", "description", "category"]


class SKUSerializer(serializers.ModelSerializer):
    class Meta:
        model = SKU
        fields = ["id", "code", "product", "fefo_days"]


class PromotionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promotion
        fields = [
            "id",
            "name",
            "description",
            "percent_off",
            "active",
            "priority",
            "starts_at",
            "ends_at",
        ]

