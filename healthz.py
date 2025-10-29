"""Endpoint de salud simple (Grupo #6)."""
from django.http import JsonResponse


def healthz(request):
    """Responde OK para healthchecks en Docker/Nginx."""
    return JsonResponse({"ok": True})
