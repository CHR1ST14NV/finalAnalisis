from django.urls import path
from .views import OrderView, OrderConfirmView

urlpatterns = [
    path("", OrderView.as_view(), name="orders"),
    path("<uuid:pk>/confirm/", OrderConfirmView.as_view(), name="order-confirm"),
]

