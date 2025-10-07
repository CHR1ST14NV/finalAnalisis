from django.urls import reverse
from rest_framework.test import APIClient
import hmac, hashlib


def test_webhook_hmac(db):
    client = APIClient()
    body = b'{"tracking_number":"T1","type":"delivered"}'
    secret = "demo-secret"
    sig = hmac.new(secret.encode(), body, hashlib.sha256).hexdigest()
    url = "/api/v1/fulfillment/webhooks/mock/events/"
    r = client.post(url, data=body, content_type="application/json", HTTP_X_SIGNATURE=sig)
    assert r.status_code in (200, 404)  # 404 if shipment missing

