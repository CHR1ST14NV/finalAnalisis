from django.contrib import admin
from django.contrib.auth import get_user_model
from .models import Role, Permission, ApiKey

User = get_user_model()


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ("username", "email", "is_superuser")
    search_fields = ("username", "email")


admin.site.register(Role)
admin.site.register(Permission)
admin.site.register(ApiKey)

