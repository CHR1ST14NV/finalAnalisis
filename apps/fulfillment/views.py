from __future__ import annotations
import time
from rest_framework import status, views
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.core.cache import cache
from django.shortcuts import get_object_or_404
from django.utils.crypto import constant_time_compare
from django.conf import settings
import hmac, hashlib
from .models import Shipment, ShipmentEvent, CarrierAccount
from .services import create_shipment_for_order
from apps.orders.models import Order


class WebhookView(views.APIView):
    permission_classes = [AllowAny]

    def post(self, request, provider: str):
        signature = request.headers.get("X-Signature", "")
        ts = request.headers.get("X-Timestamp")
        nonce = request.headers.get("X-Nonce")
        if not signature or not ts or not nonce:
            return Response({"detail": "missing auth headers"}, status=status.HTTP_401_UNAUTHORIZED)

        try:
            ts_int = int(ts)
        except Exception:
            return Response({"detail": "invalid timestamp"}, status=status.HTTP_401_UNAUTHORIZED)

        # Reject old requests (>5min)
        if abs(int(time.time()) - ts_int) > 300:
            return Response({"detail": "stale request"}, status=status.HTTP_401_UNAUTHORIZED)

        # Anti-replay using Redis
        cache_key = f"wh:{provider}:{nonce}:{ts}"
        if not cache.add(cache_key, "1", timeout=300):
            return Response({"detail": "replayed"}, status=status.HTTP_401_UNAUTHORIZED)

        # Resolve secret from carrier account or fallback env
        secret = getattr(settings, "WEBHOOK_HMAC_SECRET", None)
        acct = CarrierAccount.objects.filter(provider=provider, active=True).first()
        if acct and isinstance(acct.credentials, dict) and acct.credentials.get("webhook_secret"):
            secret = acct.credentials.get("webhook_secret")
        if not secret:
            return Response({"detail": "no secret configured"}, status=status.HTTP_503_SERVICE_UNAVAILABLE)

        payload = request.body + f".{ts}.{nonce}".encode()
        expected_sig = hmac.new(str(secret).encode(), payload, hashlib.sha256).hexdigest()
        if not constant_time_compare(signature, expected_sig):
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
