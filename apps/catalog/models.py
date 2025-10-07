import uuid
from django.db import models


def uuid7():
    return uuid.uuid4()


class Category(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    name = models.CharField(max_length=120)
    parent = models.ForeignKey(
        "self", null=True, blank=True, on_delete=models.PROTECT, related_name="children"
    )

    def __str__(self) -> str:
        return self.name


class Product(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    name = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    category = models.ForeignKey(Category, on_delete=models.PROTECT, related_name="products")

    def __str__(self) -> str:
        return self.name


class SKU(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    product = models.ForeignKey(Product, on_delete=models.PROTECT, related_name="skus")
    code = models.CharField(max_length=64, unique=True)
    fefo_days = models.IntegerField(default=0)

    def __str__(self) -> str:
        return self.code


class PriceList(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    name = models.CharField(max_length=100)
    channel = models.CharField(max_length=50, default="default")
    active = models.BooleanField(default=True)


class Price(models.Model):
    price_list = models.ForeignKey(PriceList, on_delete=models.CASCADE, related_name="prices")
    sku = models.ForeignKey(SKU, on_delete=models.PROTECT)
    currency = models.CharField(max_length=3, default="USD")
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    valid_from = models.DateTimeField()
    valid_to = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = ("price_list", "sku", "valid_from")


class Promotion(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid7, editable=False)
    name = models.CharField(max_length=120)
    description = models.TextField(blank=True)
    percent_off = models.DecimalField(max_digits=5, decimal_places=2, default=0)
    active = models.BooleanField(default=True)
    priority = models.IntegerField(default=100)
    starts_at = models.DateTimeField()
    ends_at = models.DateTimeField()
    skus = models.ManyToManyField(SKU, blank=True)

