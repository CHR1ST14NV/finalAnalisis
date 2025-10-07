import hmac
import hashlib
from decimal import Decimal
from typing import Protocol
from django.db import transaction
from django.utils.crypto import constant_time_compare
from .models import Shipment, CarrierAccount
from apps.orders.models import Order


class LogisticsProvider(Protocol):
    name: str

    def quote(self, order: Order) -> Decimal: ...
    def create_shipment(self, order: Order) -> tuple[str, Decimal]: ...  # tracking, cost


class MockProvider:
    name = "mock"

    def quote(self, order: Order) -> Decimal:
        return Decimal("5.00")

    def create_shipment(self, order: Order) -> tuple[str, Decimal]:
        return (f"TRK-{str(order.id)[:8]}", self.quote(order))


def choose_best_carrier(order: Order) -> LogisticsProvider:
    # Placeholder strategy: choose mock provider
    return MockProvider()


@transaction.atomic
def create_shipment_for_order(order: Order) -> Shipment:
    provider = choose_best_carrier(order)
    tracking, cost = provider.create_shipment(order)
    sh = Shipment.objects.create(order=order, carrier=provider.name, tracking_number=tracking, cost=cost, status=Shipment.DISPATCHED)
    return sh


def verify_hmac(payload: bytes, secret: str, signature: str) -> bool:
    h = hmac.new(secret.encode(), payload, hashlib.sha256).hexdigest()
    return constant_time_compare(h, signature)

