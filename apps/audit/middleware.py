from __future__ import annotations
from datetime import timedelta
from django.utils import timezone
from django.utils.deprecation import MiddlewareMixin
from .models import AuditLog


class AuditLogMiddleware(MiddlewareMixin):
    def process_response(self, request, response):
        try:
            actor = getattr(request.user, "username", "") if hasattr(request, "user") else ""
            ip = request.META.get("REMOTE_ADDR")
            body = ""
            if request.method in {"POST", "PUT", "PATCH"}:
                # keep it small
                body = request.body.decode(errors="ignore")[:1000]
            AuditLog.objects.create(
                actor=actor,
                ip=ip,
                method=request.method,
                path=request.path,
                request_body=body,
                response_code=response.status_code,
                ttl=timezone.now() + timedelta(days=30),
            )
        except Exception:
            pass
        return response

