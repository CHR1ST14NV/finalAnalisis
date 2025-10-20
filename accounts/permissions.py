from rest_framework.permissions import BasePermission, SAFE_METHODS


class RolePermission(BasePermission):
    allow_roles: list[str] = []
    read_only_roles: list[str] = []

    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        if user.is_superuser:
            return True
        if request.method in SAFE_METHODS and self.read_only_roles:
            return user.roles.filter(code__in=self.read_only_roles).exists()
        if self.allow_roles:
            return user.roles.filter(code__in=self.allow_roles).exists()
        return True

