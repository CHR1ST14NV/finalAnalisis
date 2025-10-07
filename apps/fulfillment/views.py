from rest_framework import status, views
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from .models import Shipment, ShipmentEvent
from .services import verify_hmac, create_shipment_for_order
from apps.orders.models import Order


class WebhookView(views.APIView):
    permission_classes = [AllowAny]

    def post(self, request, provider: str):
        signature = request.headers.get("X-Signature", "")
        secret = "demo-secret"  # in real life from Provider config/CarrierAccount
        if not verify_hmac(request.body, secret, signature):
            return Response({"detail": "invalid signature"}, status=status.HTTP_401_UNAUTHORIZED)
        payload = request.data
        tracking_number = payload.get("tracking_number")
        shipment = get_object_or_404(Shipment, tracking_number=tracking_number)
        ShipmentEvent.objects.create(shipment=shipment, provider=provider, type=payload.get("type", "event"), payload=payload)
        return Response({"ok": True})


class ShipmentCreateView(views.APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        order_id = request.data.get("order_id")
        order = get_object_or_404(Order, id=order_id)
        sh = create_shipment_for_order(order)
        return Response({"id": str(sh.id), "tracking_number": sh.tracking_number, "carrier": sh.carrier})
