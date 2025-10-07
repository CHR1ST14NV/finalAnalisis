from django.urls import include, path
from .metrics import KPIsView

urlpatterns = [
    path("auth/", include("apps.users.urls")),
    path("catalog/", include("apps.catalog.urls")),
    path("inventory/", include("apps.inventory.urls")),
    path("orders/", include("apps.orders.urls")),
    path("fulfillment/", include("apps.fulfillment.urls")),
    path("settlements/", include("apps.settlements.urls")),
    path("marketing/", include("apps.marketing.urls")),
    path("integrations/", include("apps.integrations.urls")),
    path("audit/", include("apps.audit.urls")),
    path("metrics/kpis/", KPIsView.as_view(), name="kpis"),
]
