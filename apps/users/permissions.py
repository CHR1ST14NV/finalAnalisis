from rest_framework.permissions import BasePermission, SAFE_METHODS


class IsAdmin(BasePermission):
    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and user.is_superuser)


class HasRole(BasePermission):
    required_roles: list[str] = []

    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated:
            return False
        if not self.required_roles:
            return True
        user_roles = set(request.user.roles.values_list("name", flat=True))
        return bool(set(self.required_roles) & user_roles)


class ReadOnlyOrRole(HasRole):
    def has_permission(self, request, view):
        if request.method in SAFE_METHODS:
            return True
        return super().has_permission(request, view)

