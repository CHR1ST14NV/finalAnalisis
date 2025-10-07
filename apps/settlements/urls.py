from django.urls import path
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .tasks import run_settlement


class SettlementRunView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        period = request.data.get("period", "monthly")
        run_settlement.delay(period)
        return Response({"status": "queued", "period": period})


urlpatterns = [
    path("run/", SettlementRunView.as_view(), name="settlement-run"),
]

