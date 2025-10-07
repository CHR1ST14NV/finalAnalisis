from django.urls import path
from .views import AvailabilityView, ReservationView, ReservationConfirmView

urlpatterns = [
    path("availability/", AvailabilityView.as_view(), name="availability"),
    path("reservations/", ReservationView.as_view(), name="reservations"),
    path("reservations/<uuid:pk>/confirm/", ReservationConfirmView.as_view(), name="reservation-confirm"),
]

