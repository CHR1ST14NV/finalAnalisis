from rest_framework import serializers
from django.utils import timezone
from .models import Product, SKU, Category, Promotion, Price, PriceList


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name", "parent"]


class ProductSerializer(serializers.ModelSerializer):
    category = CategorySerializer(read_only=True)
    price = serializers.SerializerMethodField()
    primary_sku_id = serializers.SerializerMethodField()

    class Meta:
        model = Product
        fields = ["id", "name", "description", "category", "price", "primary_sku_id"]

    def get_price(self, obj: Product):
        now = timezone.now()
        pl = PriceList.objects.filter(active=True).first()
        if not pl:
            return None
        sku = obj.skus.first()
        if not sku:
            return None
        p = (
            Price.objects.filter(price_list=pl, sku=sku, valid_from__lte=now)
            .order_by("-valid_from")
            .first()
        )
        return {"currency": p.currency, "amount": str(p.amount)} if p else None

    def get_primary_sku_id(self, obj: Product):
        sku = obj.skus.first()
        return str(sku.id) if sku else None


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

