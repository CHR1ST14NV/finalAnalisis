from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework import status
from .serializers import RegisterSerializer, RoleSerializer
from .models import Role


class RegisterView(APIView):
    # Solo usuarios autenticados; validaremos rol ADMIN abajo
    permission_classes = [IsAuthenticated]

    def post(self, request):
        # Requiere rol ADMIN (o superusuario)
        u = request.user
        if not getattr(u, 'has_role', None) or not u.has_role(Role.ADMIN):
            return Response({'detail': 'Forbidden'}, status=status.HTTP_403_FORBIDDEN)
        s = RegisterSerializer(data=request.data)
        s.is_valid(raise_exception=True)
        user = s.save()
        return Response({'id': user.id, 'username': user.username}, status=status.HTTP_201_CREATED)


class RoleListView(APIView):
    # Requiere autenticación (visible desde UI de admin)
    permission_classes = [IsAuthenticated]

    def get(self, request):
        data = RoleSerializer(Role.objects.all(), many=True).data
        return Response(data)


class MeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        u = request.user
        roles = list(u.roles.values('id', 'code', 'name')) if hasattr(u, 'roles') else []
        return Response({
            'id': str(u.id),
            'username': u.username,
            'email': getattr(u, 'email', None),
            'first_name': getattr(u, 'first_name', ''),
            'last_name': getattr(u, 'last_name', ''),
            'roles': roles,
        })
