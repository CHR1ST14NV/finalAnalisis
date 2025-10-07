from django.urls import path
from .views import WebhookView, ShipmentCreateView

urlpatterns = [
    path("shipments/", ShipmentCreateView.as_view(), name="shipment-create"),
    path("webhooks/<str:provider>/events/", WebhookView.as_view(), name="fulfillment-webhook"),
]
