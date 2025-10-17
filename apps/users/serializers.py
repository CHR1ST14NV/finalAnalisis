from django.contrib.auth import get_user_model
from rest_framework import serializers
from .models import Role

User = get_user_model()


class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = ["name", "description"]


class UserSerializer(serializers.ModelSerializer):
    roles = RoleSerializer(many=True, read_only=True)

    class Meta:
        model = User
        fields = ["id", "username", "email", "first_name", "last_name", "roles"]
        read_only_fields = ["id", "roles"]
