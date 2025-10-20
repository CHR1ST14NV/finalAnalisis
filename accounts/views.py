from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework import status
from .serializers import RegisterSerializer, RoleSerializer
from .models import Role


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        s = RegisterSerializer(data=request.data)
        s.is_valid(raise_exception=True)
        user = s.save()
        return Response({'id': user.id, 'username': user.username}, status=status.HTTP_201_CREATED)


class RoleListView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        data = RoleSerializer(Role.objects.all(), many=True).data
        return Response(data)

