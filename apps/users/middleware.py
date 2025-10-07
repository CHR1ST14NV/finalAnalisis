import hashlib
from typing import Optional
from django.core.cache import cache
from django.http import HttpRequest, HttpResponse, JsonResponse
from django.utils.deprecation import MiddlewareMixin


class IdempotencyKeyMiddleware(MiddlewareMixin):
    """Simple idempotency for mutating requests using Redis cache.

    Expects header: Idempotency-Key
    Stores a short TTL token to prevent duplicates.
    """

    TTL_SECONDS = 60 * 10

    def process_request(self, request: HttpRequest) -> Optional[HttpResponse]:
        if request.method in {"GET", "HEAD", "OPTIONS"}:
            return None

        key = request.headers.get("Idempotency-Key")
        if not key:
            return None
        payload = request.body or b""
        h = hashlib.sha256(payload).hexdigest()
        cache_key = f"idem:{request.method}:{request.path}:{key}:{h}"
        exists = cache.add(cache_key, "1", timeout=self.TTL_SECONDS)
        if not exists:
            return JsonResponse(
                {"detail": "Duplicate request"}, status=409
            )
        return None

